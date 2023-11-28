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

{ #category : 'accessing' }
IGNamespace >> functions [

	^ self elements select: [ :each | each isFunction ]
]

{ #category : 'testing' }
IGNamespace >> hasFunctions [

	^ self functions notEmpty
]

{ #category : 'testing' }
IGNamespace >> isNamespace [

	^ true
]

{ #category : 'accessing' }
IGNamespace >> phDeclarationWith: aPrefix [

	^ (super phDeclarationWith: aPrefix), 'Namespace'

]
