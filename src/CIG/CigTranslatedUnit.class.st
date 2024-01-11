"
Contains the translated node tree taken from traversing the libclang cursor.

The method `CigTranslatedUnit>>#generateFrom:` takes a `CigLibraryGenerator` instance and performs the AST traverse to form the node tree.
"
Class {
	#name : 'CigTranslatedUnit',
	#superclass : 'Object',
	#traits : 'CigTElementContainer',
	#classTraits : 'CigTElementContainer classTrait',
	#instVars : [
		'nodeClasses',
		'registerUnknown',
		'prefix',
		'namespaces',
		'defines',
		'definesBeforeHeader'
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
CigTranslatedUnit >> acceptNestedClasses [
	
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
	| parent current |

	currentNode location isInSystemHeader ifTrue: [ ^ self ]. 	

	parent := self findParent: parentNode.
	(self findNode: currentNode startingAt: parent ifAbsent: [ nil ]) 
		ifNotNil: [ ^ self ]. 

	current := self newNode: currentNode.	
	(current isUnknown and: [ self isGeneratingWithUnknown not ])
		ifTrue: [ ^ self ].

	(current canBeAddedTo: parent) ifFalse: [ ^ self ].
	parent addElement: current
]

{ #category : 'accessing' }
CigTranslatedUnit >> allDefines [

	^ self definesBeforeHeader, self defines
]

{ #category : 'accessing' }
CigTranslatedUnit >> defines [

	^ defines
]

{ #category : 'accessing' }
CigTranslatedUnit >> definesBeforeHeader [

	^ definesBeforeHeader
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

{ #category : 'private' }
CigTranslatedUnit >> findElementMatching: aBlock [

	^ self elements
		detect: [ :eachElement | aBlock value: eachElement ]
		ifNone: [ nil ]
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
	
	parents := aCursor withAllParents.
	
	current := self.
	parents allButFirst do: [ :each |
		| next |
		next := current findElementMatchingCursor: each.
		next ifNil: [ ^ current ].
		current := next ].
	
	^ current 
]

{ #category : 'generating' }
CigTranslatedUnit >> generateFrom: aHeader [
	"makes a tree of elements I can use to generate the wrapper file and classes."

	"initialize variables"
	prefix := aHeader prefix.
	namespaces := aHeader namespaces.
	definesBeforeHeader := aHeader cDefinesBeforeHeader.
	defines := aHeader cDefines.
	elements := OrderedCollection new.
	self traverseASTWith: aHeader.
	"add special elements at the end"
	elements addAll: self specialElements
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
CigTranslatedUnit >> isGeneratingWithUnknown [

	^ registerUnknown
]

{ #category : 'private' }
CigTranslatedUnit >> isNamespace [
	"for polymorphism with elements"
	
	^ false
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

{ #category : 'accessing' }
CigTranslatedUnit >> root [
	
	^ self
]

{ #category : 'accessing' }
CigTranslatedUnit >> scopeLookupPath: aPath [

	^ self elementAtPath: aPath
]

{ #category : 'utils' }
CigTranslatedUnit >> selectTemplateClasses [
	
	^ Array streamContents: [ :stream |
		self traverseElementsDo: [ :each | 
			each isClassTemplate
				ifTrue: [ stream << each ] ] ]
]

{ #category : 'utils' }
CigTranslatedUnit >> selectVariadicFunctions [
	
	^ Array streamContents: [ :stream |
		self traverseElementsDo: [ :each | 
			((each isFunction or: [ each isClassMember ])
			and: [ each isVariadic ])
			ifTrue: [ stream << each ] ] ]
]

{ #category : 'private' }
CigTranslatedUnit >> specialElements [
	"a place to keep special elements with special templates (like std namespace)"
	
	^ CigSpecialElement allElements
		collect: [ :each | each parent: self; yourself ]
]

{ #category : 'generating' }
CigTranslatedUnit >> traverseASTWith: aHeader [
	| index tu cursor |
	
	index := CXIndex createIndex: 0 diagnostics: 0. 
	tu := CXTranslationUnit 
		parseIndex: index 
		fileName: aHeader fileReference fullName
		arguments: {
				'-E'.
				'-xc++'.
			}, 
			aHeader cIncludePathsAsArguments,
			aHeader cDefinesBeforeHeaderAsArguments,
			aHeader cDefinesAsArguments.

	cursor := tu cursor.
	cursor visitChildren: [ :current :parent :data |
		self addNode: current parent: parent.
		CXChildVisit recurse ].

	tu dispose.
	index dispose
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

{ #category : 'utils' }
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
