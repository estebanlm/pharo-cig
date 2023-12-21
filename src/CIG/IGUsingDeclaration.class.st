Class {
	#name : 'IGUsingDeclaration',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGUsingDeclaration class >> kind [
	
	^ CXCursor_UsingDeclaration
]

{ #category : 'visiting' }
IGUsingDeclaration >> accept: aVisitor [

	aVisitor visitUsingDeclaration: self
]

{ #category : 'accessing' }
IGUsingDeclaration >> cppDeclaration [

	^ '::' join: (self elements collect: [ :each | each name ])
]

{ #category : 'testing' }
IGUsingDeclaration >> isDeclaringClass [

	^ self elements 
		detect: [ :each | each kind = CXCursor_OverloadedDeclRef ]
		ifFound: [ :each | each isDeclaringClass ]
		ifNone: [ false ]
]

{ #category : 'testing' }
IGUsingDeclaration >> isDeclaringTypedef [

	^ self elements 
		detect: [ :each | each kind = CXCursor_OverloadedDeclRef ]
		ifFound: [ :each | each isDeclaringTypedef ]
		ifNone: [ false ]
]

{ #category : 'testing' }
IGUsingDeclaration >> isUsingDeclaration [

	^ true
]
