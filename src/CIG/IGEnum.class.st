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

{ #category : 'testing' }
IGEnum >> isEnum [

	^ true
]
