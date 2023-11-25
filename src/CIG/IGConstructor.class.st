Class {
	#name : 'IGConstructor',
	#superclass : 'IGClassMember',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGConstructor class >> kind [
	
	^ CXCursor_Constructor
]

{ #category : 'visiting' }
IGConstructor >> accept: aVisitor [

	aVisitor visitConstructor: self
]
