Class {
	#name : 'IGEnum',
	#superclass : 'IGElement',
	#instVars : [
		'elements'
	],
	#category : 'LibClang-IG',
	#package : 'LibClang-IG'
}

{ #category : 'visiting' }
IGEnum >> accept: aVisitor [

	aVisitor visitEnum: self
]

{ #category : 'accessing' }
IGEnum >> addElement: anElement [

	anElement parent: self.
	elements add: anElement
]

{ #category : 'accessing' }
IGEnum >> elements [

	^ elements
]

{ #category : 'accessing' }
IGEnum >> fullName [

	^ self parent
		ifNotNil: [ self parent name, '::', self name ] 
		ifNil: [ self name ]
]

{ #category : 'initialization' }
IGEnum >> initialize [

	super initialize.
	elements := OrderedCollection new
]

{ #category : 'testing' }
IGEnum >> isEnum [

	^ true
]

{ #category : 'testing' }
IGEnum >> matchesCursor: aCursor [

	^ aCursor isEnumDeclaration and: [ aCursor displayName = self name ]
]
