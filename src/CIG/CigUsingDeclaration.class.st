Class {
	#name : 'CigUsingDeclaration',
	#superclass : 'CigElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigUsingDeclaration class >> kind [
	
	^ CXCursor_UsingDeclaration
]

{ #category : 'visiting' }
CigUsingDeclaration >> accept: aVisitor [

	aVisitor visitUsingDeclaration: self
]

{ #category : 'accessing' }
CigUsingDeclaration >> cppDeclaration [

	^ '::' join: (self elements collect: [ :each | each name ])
]

{ #category : 'testing' }
CigUsingDeclaration >> isDeclaringClass [

	^ self elements 
		detect: [ :each | each kind = CXCursor_OverloadedDeclRef ]
		ifFound: [ :each | each isDeclaringClass ]
		ifNone: [ false ]
]

{ #category : 'testing' }
CigUsingDeclaration >> isDeclaringTypedef [

	^ self elements 
		detect: [ :each | each kind = CXCursor_OverloadedDeclRef ]
		ifFound: [ :each | each isDeclaringTypedef ]
		ifNone: [ false ]
]

{ #category : 'testing' }
CigUsingDeclaration >> isUsingDeclaration [

	^ true
]
