Class {
	#name : 'IGTypeReference',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGTypeReference class >> kind [
	
	^ CXCursor_TypeRef
]

{ #category : 'visiting' }
IGTypeReference >> accept: aVisitor [

	"Used by its parent"
]

{ #category : 'testing' }
IGTypeReference >> isTypeReference [

	^ true
]

{ #category : 'testing' }
IGTypeReference >> isUnknown [

	^ self referenceType = IGUnknown
]

{ #category : 'as yet unclassified' }
IGTypeReference >> namePath [
	
	^ self typeName substrings: '::'
]

{ #category : 'accessing' }
IGTypeReference >> referenceType [
	| typeString |

	self flag: #TODO. "This can be refactored to an object hierarchy?"

	typeString := self name copyUpTo: Character space.
	typeString = 'class' ifTrue: [ ^ IGClass ].
	typeString = 'struct' ifTrue: [ ^ IGStructure ].
	typeString = 'enum' ifTrue: [ ^ IGEnum ].
	
	^ IGUnknown
]

{ #category : 'accessing' }
IGTypeReference >> typeBasename [
	
	^ self typeName copyAfterLast: $:
]

{ #category : 'accessing' }
IGTypeReference >> typeKind [
	
	^ self referenceType kind
]

{ #category : 'accessing' }
IGTypeReference >> typeName [

	^ (self name includes: Character space) 
		ifTrue: [ self name copyAfter: Character space ]
		ifFalse: [ self name ]

]
