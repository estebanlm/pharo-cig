Class {
	#name : 'IGOverloadedDeclRef',
	#superclass : 'IGReference',
	#instVars : [
		'declarations'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGOverloadedDeclRef class >> kind [

	^ CXCursor_OverloadedDeclRef
]

{ #category : 'visiting' }
IGOverloadedDeclRef >> accept: aVisitor [

]

{ #category : 'initialization' }
IGOverloadedDeclRef >> fromCursor: aCursor [

	super fromCursor: aCursor.
	declarations := (aCursor overloadedDeclarations 
		collect: [ :each | each displayName -> each kind ])
		as: Dictionary
]

{ #category : 'testing' }
IGOverloadedDeclRef >> isDeclaringClass [

	^ declarations anySatisfy: [ :each | each value = CXCursor_ClassDecl ]
]

{ #category : 'testing' }
IGOverloadedDeclRef >> isDeclaringTypedef [

	^ declarations anySatisfy: [ :each | each value = CXCursor_TypedefDecl ]
]
