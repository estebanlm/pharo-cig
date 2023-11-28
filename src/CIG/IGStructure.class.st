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

{ #category : 'field definition' }
IGStructure >> fields [
	
	^ self elements select: [ :each | each isField ]
]
