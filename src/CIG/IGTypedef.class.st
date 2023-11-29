Class {
	#name : 'IGTypedef',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGTypedef class >> kind [
	
	^ CXCursor_TypedefDecl
]

{ #category : 'visiting' }
IGTypedef >> accept: aVisitor [
	
	aVisitor visitTypedef: self
]

{ #category : 'accessing' }
IGTypedef >> resolveType [
	
	^ IGType new
		parent: self;
		name: self name;
		reference: self typeReference;
		yourself
]
