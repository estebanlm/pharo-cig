Class {
	#name : 'IGDestructor',
	#superclass : 'IGClassElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGDestructor class >> kind [
	
	^ CXCursor_Destructor
]

{ #category : 'visiting' }
IGDestructor >> accept: aVisitor [

	aVisitor visitDestructor: self
]
