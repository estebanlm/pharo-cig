Class {
	#name : 'CigDestructor',
	#superclass : 'CigClassMember',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigDestructor class >> kind [
	
	^ CXCursor_Destructor
]

{ #category : 'visiting' }
CigDestructor >> accept: aVisitor [

	aVisitor visitDestructor: self
]

{ #category : 'testing' }
CigDestructor >> isDestructor [

	^ true
]
