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

{ #category : 'accessing' }
IGTypeReference >> referenceType [
	| typeString |

	self flag: #TODO. "This can be refactored to an object hierarchy?"

	typeString := self name copyUpTo: Character space.
	typeString = 'class' ifTrue: [ ^ IGClass ].
	typeString = 'struct' ifTrue: [ ^ IGStructure ].
	typeString = 'enum' ifTrue: [ ^ IGEnum ].
	
	self error: 'Should not arrive here.'
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

	^ self name copyAfter: Character space
]
