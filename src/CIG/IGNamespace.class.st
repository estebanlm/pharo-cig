Class {
	#name : 'IGNamespace',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'instance creation' }
IGNamespace class >> fromCursor: aCursor [

	^ self new fromCursor: aCursor
]

{ #category : 'accessing' }
IGNamespace class >> kind [

	^ CXCursor_Namespace
]

{ #category : 'visiting' }
IGNamespace >> accept: aVisitor [

	aVisitor visitNamespace: self
]

{ #category : 'testing' }
IGNamespace >> isNamespace [

	^ true
]
