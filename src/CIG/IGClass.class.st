Class {
	#name : 'IGClass',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGClass class >> kind [

	^ CXCursor_ClassDecl
]

{ #category : 'visiting' }
IGClass >> accept: aVisitor [

	aVisitor visitClass: self
]
