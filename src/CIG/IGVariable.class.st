Class {
	#name : 'IGVariable',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGVariable class >> kind [

	^ CXCursor_VarDecl
]

{ #category : 'visiting' }
IGVariable >> accept: aVisitor [

	aVisitor visitVariable: self
]
