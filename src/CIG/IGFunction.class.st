Class {
	#name : 'IGFunction',
	#superclass : 'IGElement',
	#traits : 'IGTFunction',
	#classTraits : 'IGTFunction classTrait',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGFunction class >> kind [

	^ CXCursor_FunctionDecl
]

{ #category : 'visiting' }
IGFunction >> accept: aVisitor [

	aVisitor visitFunction: self
]

{ #category : 'initialization' }
IGFunction >> fromCursor: aCursor [

	super fromCursor: aCursor.
	self fillFunctionWith: aCursor
]

{ #category : 'accessing' }
IGFunction >> pathName [

	^ self spelling
]
