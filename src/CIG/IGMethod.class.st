Class {
	#name : 'IGMethod',
	#superclass : 'IGClassElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGMethod class >> kind [
	
	^ CXCursor_CXXMethod
]

{ #category : 'visiting' }
IGMethod >> accept: aVisitor [

	aVisitor visitMethod: self
]
