Class {
	#name : 'CigOverloadedDeclRef',
	#superclass : 'CigReference',
	#instVars : [
		'declarations'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigOverloadedDeclRef class >> kind [

	^ CXCursor_OverloadedDeclRef
]

{ #category : 'visiting' }
CigOverloadedDeclRef >> accept: aVisitor [

]

{ #category : 'initialization' }
CigOverloadedDeclRef >> fromCursor: aCursor [

	super fromCursor: aCursor.
	declarations := (aCursor overloadedDeclarations 
		collect: [ :each | each displayName -> each kind ])
		as: Dictionary
]

{ #category : 'testing' }
CigOverloadedDeclRef >> isDeclaringClass [

	^ declarations anySatisfy: [ :each | each value = CXCursor_ClassDecl ]
]

{ #category : 'testing' }
CigOverloadedDeclRef >> isDeclaringTypedef [

	^ declarations anySatisfy: [ :each | each value = CXCursor_TypedefDecl ]
]
