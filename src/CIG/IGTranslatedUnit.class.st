"
Contains the translated nodes taken from traversing the libclang cursor.

The method `IGTranslatedUnit>>#generateFrom:` takes a `ICHeaderGenerator` instance and performs the AST traverse to form the node tree.
"
Class {
	#name : 'IGTranslatedUnit',
	#superclass : 'Object',
	#classTraits : 'IGTElementContainer classTrait',
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
IGTranslatedUnit >> accept: aVisitor [ 

	aVisitor visitUnit: self
]

{ #category : 'visiting' }
IGTranslatedUnit >> acceptNestedClasses [
	
	^ true
]

{ #category : 'accessing' }
IGTranslatedUnit >> addElement: anElement [

	elements ifNil: [ elements := OrderedCollection new ].
	anElement parent: self.
	elements add: anElement
]

{ #category : 'private' }
IGTranslatedUnit >> addNode: currentNode parent: parentNode [
	| parent current pass |

	currentNode location isInSystemHeader ifTrue: [ ^ self ]. 	

	pass := false.
	parent := self findParent: parentNode.
	(parent name = 'text')
		ifTrue: [ 
			pass := true.
			(currentNode withAllParents allButFirst collect: #displayName) crTrace.
			currentNode displayName crTrace ].	

	(self findNode: currentNode startingAt: parent ifAbsent: [ nil ]) 
		ifNotNil: [ ^ self ]. 

	pass ifTrue: [ '<enter>' crTrace ].

	current := self newNode: currentNode.	
	(current isUnknown and: [ self isGeneratingWithUnknown not ])
		ifTrue: [ ^ self ].

	(current canBeAddedTo: parent) ifFalse: [ ^ self ].
	parent addElement: current
]

{ #category : 'accessing' }
IGTranslatedUnit >> allDefines [

	^ self definesBeforeHeader, self defines
]

{ #category : 'accessing' }
IGTranslatedUnit >> defines [

	^ defines
]

{ #category : 'accessing' }
IGTranslatedUnit >> definesBeforeHeader [

	^ definesBeforeHeader
]

{ #category : 'accessing' }
IGTranslatedUnit >> elementAtPath: aPath [
	| current |

	current := self.
	aPath do: [ :each |
		current := current findElementMatching: [ :eachElement | eachElement isEqualToPath: each ] ].
	^ current
]

{ #category : 'accessing' }
IGTranslatedUnit >> elements [

	^ elements ifNil: [ #() ]
]

{ #category : 'accessing' }
IGTranslatedUnit >> findDeepElementMatching: aBlock [

	self elements do: [ :eachElement |
		(eachElement findDeepElementMatching: aBlock) 
			ifNotNil: [ :found | ^ found ] ].

	^ nil
]

{ #category : 'private' }
IGTranslatedUnit >> findElementMatching: aBlock [

	^ self elements
		detect: [ :eachElement | aBlock value: eachElement ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
IGTranslatedUnit >> findElementMatchingCursor: aCursor [

	^ self elements 
		detect: [ :each | each matchesCursor: aCursor ]
		ifNone: [ nil ]
]

{ #category : 'private' }
IGTranslatedUnit >> findNode: aCursor startingAt: aNode ifAbsent: aBlock [
	| kind name result |
	
	kind := aCursor kind.
	name := aCursor displayName.
	
	result := aNode findDeepElementMatching: [ :each | 
		each kind = kind and: [ each name = name ] ].
	
	result ifNil: [ ^ aBlock value ].
	
	^ result
]

{ #category : 'private' }
IGTranslatedUnit >> findParent: aCursor [
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
IGTranslatedUnit >> generateFrom: aHeader [
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
IGTranslatedUnit >> hasElements [

	^ elements notNil
]

{ #category : 'initialization' }
IGTranslatedUnit >> initialize [

	super initialize.
	elements := OrderedCollection new.
	self withUnknown
]

{ #category : 'inspecting' }
IGTranslatedUnit >> inspectionElements [
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
IGTranslatedUnit >> installedNamespaceFor: aNamespace [
	| originName |

	originName := aNamespace originNamespaceName.
	^ namespaces
		detect: [ :each | each cppName = originName ]
		ifNone: [ nil ]
]

{ #category : 'testing' }
IGTranslatedUnit >> isGeneratingWithUnknown [

	^ registerUnknown
]

{ #category : 'private' }
IGTranslatedUnit >> isNamespace [
	"for polymorphism with elements"
	
	^ false
]

{ #category : 'accessing' }
IGTranslatedUnit >> name [

	^ '__Unit__'
]

{ #category : 'private' }
IGTranslatedUnit >> newNode: currentNode [
	
	^ (self nodeClassAt: currentNode kind) fromCursor: currentNode
		
]

{ #category : 'private' }
IGTranslatedUnit >> nodeClassAt: aKind [

	^ self nodeClasses
		at: aKind
		ifAbsent: [ IGUnknown ]
]

{ #category : 'private' }
IGTranslatedUnit >> nodeClasses [
		
	^ nodeClasses ifNil: [ 
		nodeClasses := IGElement nodesDictionary ]
]

{ #category : 'accessing' }
IGTranslatedUnit >> path [
	
	^ { self prefix 
		ifNotNil: [ :aString | aString asLowercase ]
		ifNil: [ '' ] }
]

{ #category : 'accessing' }
IGTranslatedUnit >> prefix [

	^ prefix
]

{ #category : 'accessing' }
IGTranslatedUnit >> root [
	
	^ self
]

{ #category : 'utils' }
IGTranslatedUnit >> selectTemplateClasses [
	
	^ Array streamContents: [ :stream |
		self traverseElementsDo: [ :each | 
			each isClassTemplate
				ifTrue: [ stream << each ] ] ]
]

{ #category : 'utils' }
IGTranslatedUnit >> selectVariadicFunctions [
	
	^ Array streamContents: [ :stream |
		self traverseElementsDo: [ :each | 
			((each isFunction or: [ each isClassMember ])
			and: [ each isVariadic ])
			ifTrue: [ stream << each ] ] ]
]

{ #category : 'private' }
IGTranslatedUnit >> specialElements [
	"a place to keep special elements with special templates (like std namespace)"
	
	^ IGSpecialElement allElements
		collect: [ :each | each parent: self; yourself ]
]

{ #category : 'generating' }
IGTranslatedUnit >> traverseASTWith: aHeader [
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
IGTranslatedUnit >> traverseElementsDo: aBlock [

	self 
		traverseElementsDo: aBlock 
		excluding: Set new	
]

{ #category : 'private - traversing' }
IGTranslatedUnit >> traverseElementsDo: aBlock excluding: excludes [

	self hasElements ifFalse: [ ^ self ]. 
	self elements do: [ :each |
		each traverseElementsDo: aBlock excluding: excludes ]
]

{ #category : 'utils' }
IGTranslatedUnit >> typeSpecializationsOf: aName [

	^ IGTypeSpecializationCollector new
		typeName: aName;
		visit: self;
		collected
]

{ #category : 'accessing' }
IGTranslatedUnit >> withUnknown [

	registerUnknown := true
]

{ #category : 'accessing' }
IGTranslatedUnit >> withoutUnknown [

	registerUnknown := false
]
