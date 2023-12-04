"
Contains the translated nodes taken from traversing the libclang cursor.

The method `IGTranslatedUnit>>#generateFrom:` takes a `ICHeaderGenerator` instance and performs the AST traverse to form the node tree.
"
Class {
	#name : 'IGTranslatedUnit',
	#superclass : 'Object',
	#traits : 'IGTElementContainer',
	#classTraits : 'IGTElementContainer classTrait',
	#instVars : [
		'nodeClasses',
		'registerUnknown'
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

{ #category : 'accessing' }
IGTranslatedUnit >> addElement: anElement [

	elements ifNil: [ elements := OrderedCollection new ].
	anElement parent: self.
	elements add: anElement
]

{ #category : 'private' }
IGTranslatedUnit >> addNode: currentNode parent: parentNode [
	| parent current |

	parent := self findParent: parentNode.	
	(self findNode: currentNode startingAt: parent ifAbsent: [ nil ]) 
		ifNotNil: [ ^ self ].

	current := self newNode: currentNode.
	(current isUnknown and: [ self isGeneratingWithUnknown not ])
		ifTrue: [ ^ self ].
	parent addElement: current
]

{ #category : 'accessing' }
IGTranslatedUnit >> elementAtPath: aPath [
	| current |

	current := self.
	aPath do: [ :each |
		current := current findElementMatching: [ :eachElement | eachElement name = each ] ].
	^ current
]

{ #category : 'private' }
IGTranslatedUnit >> findNode: aNode [

	^ self 
		findNode: aNode 
		ifAbsent: [ self ]
]

{ #category : 'private' }
IGTranslatedUnit >> findNode: aCursor ifAbsent: aBlock [

	^ self 
		findNode: aCursor 
		startingAt: self 
		ifAbsent: aBlock
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
	| current parents kind name |
	
	parents := aCursor withAllParents.
	current := self.
	parents allButFirst do: [ :each |
		| next |
		kind := each kind.
		name := each displayName.
		next := current findElementMatching: [ :eachElement | 
			eachElement kind = kind and: [ eachElement name = name ] ].
		next ifNil: [ ^ current ].
		current := next ].
	
	^ current 
]

{ #category : 'accessing' }
IGTranslatedUnit >> findReversedElementMatching: aBlock [

	^ self findElementMatching: aBlock
]

{ #category : 'generating' }
IGTranslatedUnit >> generateFrom: aHeader [
	"makes a tree of elements I can use to generate the wrapper file and classes."
	| cursor tu index |
	
	elements := OrderedCollection new.

	index := CXIndex createIndex: 0 diagnostics: 0. 
	tu := CXTranslationUnit 
		parseIndex: index 
		fileName: aHeader fileReference fullName
		arguments: {
				'-E'.
				'-xc++'.
			}, 
			aHeader includePathsAsArguments.
	
	cursor := tu cursor.
	cursor visitChildren: [ :current :parent :data |
		current location isInSystemHeader 
			ifFalse: [ self addNode: current parent: parent ].
		CXChildVisit recurse ].

	tu dispose.
	index dispose
]

{ #category : 'initialization' }
IGTranslatedUnit >> initialize [

	super initialize.
	elements := OrderedCollection new.
	self withUnknown
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
	
	^ { self }
]

{ #category : 'accessing' }
IGTranslatedUnit >> root [
	
	^ self
]

{ #category : 'accessing' }
IGTranslatedUnit >> withUnknown [

	registerUnknown := true
]

{ #category : 'accessing' }
IGTranslatedUnit >> withoutUnknown [

	registerUnknown := false
]
