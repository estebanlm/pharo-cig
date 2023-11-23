Class {
	#name : 'IGEnum',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGEnum class >> kind [

	^ CXCursor_EnumDecl
]

{ #category : 'visiting' }
IGEnum >> accept: aVisitor [

	aVisitor visitEnum: self
]

{ #category : 'accessing' }
IGEnum >> fullName [

	^ self parent
		ifNotNil: [ self parent name, '::', self name ] 
		ifNil: [ self name ]
]

{ #category : 'testing' }
IGEnum >> isEnum [

	^ true
]
