"
Contains the translated node tree taken from traversing the libclang cursor.

The method `CigTranslatedUnit>>#generateFrom:` takes a `CigLibraryGenerator` instance and performs the AST traverse to form the node tree.
"
Class {
	#name : 'CigTranslatedUnit',
	#superclass : 'Object',
	#traits : 'CigTLoggeable + CigTElementContainer',
	#classTraits : 'CigTLoggeable classTrait + CigTElementContainer classTrait',
	#instVars : [
		'nodeClasses',
		'registerUnknown',
		'prefix',
		'namespaces',
		'defines',
		'definesBeforeHeader',
		'excluding'
	],
	#pools : [
		'CXCursorKind'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'visiting' }
CigTranslatedUnit >> accept: aVisitor [ 

	aVisitor visitUnit: self
]

{ #category : 'visiting' }
CigTranslatedUnit >> acceptDataStructures [
	
	^ true
]

{ #category : 'accessing' }
CigTranslatedUnit >> addElement: anElement [

	elements ifNil: [ elements := OrderedCollection new ].
	anElement parent: self.
	elements add: anElement
]

{ #category : 'private' }
CigTranslatedUnit >> addNode: currentNode parent: parentNode [
	| parent element |

	parent := self findParent: parentNode.
	(self findNode: currentNode startingAt: parent ifAbsent: [ nil ]) 
		ifNotNil: [ ^ self ]. 

	element := self newNode: currentNode.
	(element isUnknown and: [ self isGeneratingWithUnknown not ])
		ifTrue: [ ^ self ].

	(element canBeAddedTo: parent) ifFalse: [ ^ self ].
	parent addElement: element
]

{ #category : 'accessing' }
CigTranslatedUnit >> allDefines [

	^ self definesBeforeHeader, self defines
]

{ #category : 'private - generating' }
CigTranslatedUnit >> anyExclusionsMatches: currentNode [

	self flag: #TODO. "refactor this to be able to add exlusions in a non hardcoded way"

	"some headers redefine boolean. We do not want that"
	(#( bool Bool Boolean ) includes: currentNode displayName) 
		ifTrue: [ ^ true ].
	"this is coming in some cases and we don't know how to handle it"
	self flag: #TODO. "See if this is still happening with latest changes"
	^ (currentNode displayName beginsWith: 'hash<') 
		and: [ currentNode lexicalParent displayName = 'std' ]
]

{ #category : 'private - generating' }
CigTranslatedUnit >> currentIsPartOfLibrary: currentNode baseDirectory: baseDir [
	| location result |

	location := currentNode location.
	result := location isInSystemHeader not
		and: [ (self anyExclusionsMatches: currentNode) not  ].  

	^ result
]

{ #category : 'private' }
CigTranslatedUnit >> defaultClangArguments [
	
	^ self subclassResponsibility
]

{ #category : 'accessing' }
CigTranslatedUnit >> defines [

	^ defines
]

{ #category : 'accessing' }
CigTranslatedUnit >> definesBeforeHeader [

	^ definesBeforeHeader
]

{ #category : 'utilities' }
CigTranslatedUnit >> diagnosticsFrom: aHeader [
	"makes a tree of elements I can use to generate the wrapper file and classes."
	| cursor tu index diagnostics |
	
	index := CXIndex createIndex: 0 diagnostics: 0. 
	tu := CXTranslationUnit 
		parseIndex: index 
		fileName: aHeader fileReference fullName
		arguments: 
			self defaultClangArguments, 
			aHeader cIncludePathsAsArguments.
	
	elements := OrderedCollection new.
	cursor := tu cursor.
	cursor visitChildren: [ :current :parent :data |
		current location isInSystemHeader 
			ifFalse: [ elements add: current displayName -> current kindSpelling ].
		CXChildVisit recurse ].

	diagnostics := tu diagnostics.

	tu dispose.
	index dispose.
	
	^ diagnostics
]

{ #category : 'accessing' }
CigTranslatedUnit >> elementAtPath: aPath [
	| current |

	current := self.
	aPath do: [ :each |
		current ifNil: [ ^ nil ].
		current := current findElementMatching: [ :eachElement | eachElement isEqualToPath: each ] ].
	^ current
]

{ #category : 'accessing' }
CigTranslatedUnit >> elements [

	^ elements ifNil: [ #() ]
]

{ #category : 'accessing' }
CigTranslatedUnit >> findDeepElementMatching: aBlock [

	self elements do: [ :eachElement |
		(eachElement findDeepElementMatching: aBlock) 
			ifNotNil: [ :found | ^ found ] ].

	^ nil
]

{ #category : 'accessing' }
CigTranslatedUnit >> findElementMatchingCursor: aCursor [

	^ self elements 
		detect: [ :each | each matchesCursor: aCursor ]
		ifNone: [ nil ]
]

{ #category : 'private' }
CigTranslatedUnit >> findNode: aCursor startingAt: aNode ifAbsent: aBlock [
	| kind name result |
	
	kind := aCursor kind.
	name := aCursor displayName.
	
	result := aNode findDeepElementMatching: [ :each | 
		each kind = kind and: [ each name = name ] ].
	
	result ifNil: [ ^ aBlock value ].
	
	^ result
]

{ #category : 'private' }
CigTranslatedUnit >> findParent: aCursor [
	| current parents |
	
	parents := aCursor withAllLexicalParents.
	current := self.
	parents allButFirst do: [ :each |
		| next |
		next := current findElementMatchingCursor: each.
		next ifNil: [ ^ current ].
		current := next ].
	
	^ current 
]

{ #category : 'utilities' }
CigTranslatedUnit >> flatSelect: aBlock [
	
	^ Array streamContents: [ :stream |
		self traverseElementsDo: [ :each | 
			(aBlock value: each)
				ifTrue: [ stream << each ] ] ]
]

{ #category : 'generating' }
CigTranslatedUnit >> generateFrom: aHeader [
	"makes a tree of elements I can use to generate the wrapper file and classes."

	"initialize variables"
	prefix := aHeader prefix.
	namespaces := aHeader namespaces.
	definesBeforeHeader := aHeader cDefinesBeforeHeader.
	defines := aHeader cDefines.
	excluding := aHeader excluding.
	elements := OrderedCollection new.
	
	self preprocess: aHeader.
	aHeader imports valuesDo: [ :each |
		self generateTarget: each from: aHeader ]
]

{ #category : 'generating' }
CigTranslatedUnit >> generateTarget: aTarget from: aHeader [
	| index unit cursor fileName baseDirectory |

	self logInfo: 'Processing ', aTarget name, '...'.
	
	fileName := self resolveIncludeFileName: aTarget name.
	baseDirectory := fileName asFileReference parent fullName.
	index := CXIndex createIndex: 0 diagnostics: 0. 
	unit := CXTranslationUnit 
		parseIndex: index 
		fileName: fileName
		arguments: 
			self defaultClangArguments, 
			aHeader cIncludePathsAsArguments,
			aHeader cDefinesBeforeHeaderAsArguments,
			aHeader cDefinesAsArguments.

	cursor := unit cursor.
	cursor visitChildren: [ :current :parent :data |
		[ 
			(self currentIsPartOfLibrary: current baseDirectory: baseDirectory)
				ifTrue: [
					self logDebug: '- ', current displayName, ' included.'.
					aTarget 
						processNode: current
						ifAdd: [ self addNode: current parent: parent ]
						ifInsert: [ self insertNode: current ].
					CXChildVisit recurse ]
				ifFalse: [
					self logDebug: '- ', current displayName, ' skipped.'.
					CXChildVisit continue ] ]
		on: Error 
		fork: [ :e | e pass ] 
		return: [ 
			self logDebug: 'BREAK'.
			CXChildVisit break ] ].

	unit dispose.
	index dispose.
	
	self logInfo: 'Finished.'
]

{ #category : 'testing' }
CigTranslatedUnit >> hasElements [

	^ elements notNil
]

{ #category : 'initialization' }
CigTranslatedUnit >> initialize [

	super initialize.
	elements := OrderedCollection new.
	self withUnknown
]

{ #category : 'private' }
CigTranslatedUnit >> insertElement: element [
	"inserts an element. 
	 oposite to #addElement: it inserts it in its path, by creating namespaces between the 
	 root at the element if needed."

	self 
		insertElement: element 
		at: element parent path allButFirst
]

{ #category : 'private' }
CigTranslatedUnit >> insertElement: anElement at: aPath [
	"complement of #insertElement: (see there for details). 
	 this method should not be used directly."

	"root element"
	aPath ifEmpty: [ 
		self addElement: anElement.
		^ anElement ].

	"look for path to add element"
	(self elementAtPath: aPath) ifNotNil: [ :parent | 
		parent addElement: anElement.
		^ anElement ].
	
	"add an empty namespace and then add the element there"
	(self 
		insertElement: (CigNamespace newName: aPath last path: aPath)
		at: aPath allButLast)
		addElement: anElement.

	^ anElement
]

{ #category : 'private' }
CigTranslatedUnit >> insertNode: aCursor [
	"inserts an element. 
	 oposite to #addElement: it inserts it in its path, by creating namespaces between the 
	 root at the element if needed."

	| element |
	element := self newNode: aCursor.
	self insertElement: element at: aCursor semanticParent semanticPath
]

{ #category : 'inspecting' }
CigTranslatedUnit >> inspectionElements [
	<inspectorPresentationOrder: 910 title: 'Elements'>
	
	^ SpTablePresenter new 
		beResizable;
		items: self elements;
		addColumn: ((SpStringTableColumn title: 'Type' evaluated: #className) 
			beSortable;
			width: 120;
			yourself);
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name) beSortable;
		yourself
]

{ #category : 'private' }
CigTranslatedUnit >> installedNamespaceFor: aNamespace [
	| originName |

	originName := aNamespace originNamespaceName.
	^ self namespaces
		detect: [ :each | each cppName = originName ]
		ifNone: [ nil ]
]

{ #category : 'testing' }
CigTranslatedUnit >> isCPP [

	^ false
]

{ #category : 'testing' }
CigTranslatedUnit >> isExcludedFromExport: anElement [

	^ excluding includes: anElement cppDeclaration
]

{ #category : 'testing' }
CigTranslatedUnit >> isGeneratingWithUnknown [

	^ registerUnknown
]

{ #category : 'testing' }
CigTranslatedUnit >> isNamespace [
	"for polymorphism with elements"
	
	^ false
]

{ #category : 'testing' }
CigTranslatedUnit >> isPublic: anElement [

	^ true
]

{ #category : 'testing' }
CigTranslatedUnit >> isStructure [
	
	^ false
]

{ #category : 'utilities' }
CigTranslatedUnit >> listElementsFrom: aHeader [
	"makes a tree of elements I can use to generate the wrapper file and classes."
	| cursor tu index |
	
	index := CXIndex createIndex: 0 diagnostics: 0. 
	tu := CXTranslationUnit 
		parseIndex: index 
		fileName: aHeader fileReference fullName
		arguments: 
			self defaultClangArguments, 
			aHeader cIncludePathsAsArguments.
	
	elements := OrderedCollection new.
	cursor := tu cursor.
	cursor visitChildren: [ :current :parent :data |
		current location isInSystemHeader 
			ifFalse: [ elements add: current displayName -> current kindSpelling ].
		CXChildVisit recurse ].

	tu dispose.
	index dispose.
	
	^ elements
]

{ #category : 'accessing' }
CigTranslatedUnit >> name [

	^ '__Unit__'
]

{ #category : 'accessing' }
CigTranslatedUnit >> namespaces [

	^ namespaces
]

{ #category : 'private' }
CigTranslatedUnit >> newNode: currentNode [
	
	^ (self nodeClassAt: currentNode kind) fromCursor: currentNode
		
]

{ #category : 'private' }
CigTranslatedUnit >> nodeClassAt: aKind [

	^ self nodeClasses
		at: aKind
		ifAbsent: [ CigUnknown ]
]

{ #category : 'private' }
CigTranslatedUnit >> nodeClasses [
		
	^ nodeClasses ifNil: [ 
		nodeClasses := CigElement nodesDictionary ]
]

{ #category : 'accessing' }
CigTranslatedUnit >> path [
	
	^ { self prefix 
		ifNotNil: [ :aString | aString asLowercase ]
		ifNil: [ '' ] }
]

{ #category : 'accessing' }
CigTranslatedUnit >> prefix [

	^ prefix
]

{ #category : 'private' }
CigTranslatedUnit >> prefix: aString [ 

	"this is used for tests"
	prefix := aString
]

{ #category : 'private - generating' }
CigTranslatedUnit >> preprocess: aHeader [

	"Add predefined typedefs if any"
	(aHeader cTypedefs ifNil: [ #() ]) do: [ :each |
		self addElement: (CigTypedef
			newName: each key 
			type: each value) ]
]

{ #category : 'utilities' }
CigTranslatedUnit >> removeAllUnknowns [

	self traverseElementsDo: [ :eachElement | 
		eachElement elements removeAll: (eachElement elements select: [ :each | each isUnknown ]) ]
]

{ #category : 'private' }
CigTranslatedUnit >> resolveIncludeFileName: aString [

	"resolve the easy way: if is an absolute path or a relative to something 
	 the system can find, answer it"
	aString asFileReference exists ifTrue: [ ^ aString ].
	
	^ self resolveIncludeFileNameFromTranslationUnit: aString	
]

{ #category : 'private' }
CigTranslatedUnit >> resolveIncludeFileNameFromTranslationUnit: aString [	
	"use a translation unit on a fake file to find it. This is a kind of a hack,
	 but accordingly to the collective knowledge, the only way of getting this value
	 from libclang"

	^ CigImportResolver new 
		arguments: self defaultClangArguments;
		import: aString;
		resolve
]

{ #category : 'accessing' }
CigTranslatedUnit >> root [
	
	^ self
]

{ #category : 'accessing' }
CigTranslatedUnit >> scopeLookupPath: aPath [

	^ self elementAtPath: aPath
]

{ #category : 'utilities' }
CigTranslatedUnit >> selectTemplateClasses [
	
	^ Array streamContents: [ :stream |
		self traverseElementsDo: [ :each | 
			each isClassTemplate
				ifTrue: [ stream << each ] ] ]
]

{ #category : 'utilities' }
CigTranslatedUnit >> selectVariadicFunctions [
	
	^ Array streamContents: [ :stream |
		self traverseElementsDo: [ :each | 
			((each isFunction or: [ each isClassMember ])
			and: [ each isVariadic ])
			ifTrue: [ stream << each ] ] ]
]

{ #category : 'testing' }
CigTranslatedUnit >> shouldIncludeUnitPrefixOnFullName [

	^ true
]

{ #category : 'private - traversing' }
CigTranslatedUnit >> traverseElementsDo: aBlock [

	self 
		traverseElementsDo: aBlock 
		excluding: Set new	
]

{ #category : 'private - traversing' }
CigTranslatedUnit >> traverseElementsDo: aBlock excluding: excludes [

	self hasElements ifFalse: [ ^ self ]. 
	self elements do: [ :each |
		each traverseElementsDo: aBlock excluding: excludes ]
]

{ #category : 'utilities' }
CigTranslatedUnit >> typeSpecializationsOf: aName [

	^ CigTypeSpecializationCollector new
		typeName: aName;
		visit: self;
		collected
]

{ #category : 'accessing' }
CigTranslatedUnit >> withUnknown [

	registerUnknown := true
]

{ #category : 'accessing' }
CigTranslatedUnit >> withoutUnknown [

	registerUnknown := false
]
