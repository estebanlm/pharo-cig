Class {
	#name : 'IGElement',
	#superclass : 'Object',
	#instVars : [
		'name',
		'parent'
	],
	#category : 'LibClang-IG',
	#package : 'LibClang-IG'
}

{ #category : 'instance creation' }
IGElement class >> fromCursor: aCursor [

	^ self new fromCursor: aCursor
]

{ #category : 'comparing' }
IGElement >> = other [

	^ self species = other species 
		and: [ self name = other name ]
]

{ #category : 'visiting' }
IGElement >> accept: aVisitor [

	self subclassResponsibility
]

{ #category : 'accessing' }
IGElement >> findElementMatching: aBlock [

	^ (aBlock value: self)
		ifTrue: [ self ]
		ifFalse: [ nil ]
]

{ #category : 'accessing' }
IGElement >> findElementMatchingCursor: aCursor [

	(self matchesCursor: aCursor) 
		ifTrue: [ ^ self ].
	^ nil
]

{ #category : 'initialization' }
IGElement >> fromCursor: aCursor [

	name := aCursor displayName
]

{ #category : 'comparing' }
IGElement >> hash [

	^ self species hash bitXor: self name hash
]

{ #category : 'testing' }
IGElement >> matchesCursor: aCursor [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
IGElement >> name [

	^ name
]

{ #category : 'accessing' }
IGElement >> name: aString [

	name := aString
]

{ #category : 'accessing' }
IGElement >> parent [

	^ parent
]

{ #category : 'accessing' }
IGElement >> parent: anElement [

	parent := anElement
]

{ #category : 'printing' }
IGElement >> printOn: stream [

	super printOn: stream.
	stream << '(' << self name << ')'
]

{ #category : 'accessing' }
IGElement >> root [

	^ self parent 
		ifNotNil: [ self parent root ]
		ifNil: [ self ]
]
