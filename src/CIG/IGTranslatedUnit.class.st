Class {
	#name : 'IGTranslatedUnit',
	#superclass : 'Object',
	#traits : 'IGTElementContainer',
	#classTraits : 'IGTElementContainer classTrait',
	#instVars : [
		'nodeClasses'
	],
	#pools : [
		'CXCursorKind'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'private' }
IGTranslatedUnit >> addNode: currentNode parent: parentNode [
	| parent current |

	(self findNode: currentNode ifAbsent: [ nil ]) 
		ifNotNil: [ ^ self ].
	
	parent := self findNode: parentNode.
	current := self newNode: currentNode.
	parent addElement: current
]

{ #category : 'private' }
IGTranslatedUnit >> findElementMatching: aBlock [

	self elements do: [ :eachElement |
		(eachElement findElementMatching: aBlock) 
			ifNotNil: [ :found | ^ found ] ].

	^ nil
]

{ #category : 'private' }
IGTranslatedUnit >> findNode: parentNode [

	^ self 
		findNode: parentNode 
		ifAbsent: [ self ]
]

{ #category : 'private' }
IGTranslatedUnit >> findNode: parentNode ifAbsent: aBlock [
	| kind name result |
	
	kind := parentNode kind.
	name := parentNode displayName.
	
	result := self findElementMatching: [ :each | 
		each kind = kind and: [ each name = name ] ].
	
	result ifNil: [ ^ aBlock value ].
	
	^ result
]

{ #category : 'private' }
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
	elements := OrderedCollection new
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
