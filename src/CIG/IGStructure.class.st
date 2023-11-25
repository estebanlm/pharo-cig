Class {
	#name : 'IGStructure',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGStructure class >> kind [
	
	^ CXCursor_StructDecl
]

{ #category : 'visiting' }
IGStructure >> accept: aVisitor [

	aVisitor visitStructure: self
]
