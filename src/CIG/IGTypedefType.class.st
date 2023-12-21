Class {
	#name : 'IGTypedefType',
	#superclass : 'IGType',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
IGTypedefType >> cDeclaration [

	parent definesFunction 
		ifTrue: [ ^ 'void*' ].
	parent definesArray 
		ifTrue: [ ^ (IGFunctionParser parse: parent underlyingTypeName) name, '*'  ].

	^ parent underlyingTypeName
]

{ #category : 'accessing' }
IGTypedefType >> phDeclarationWith: prefix [

	parent definesFunction ifTrue: [ ^ 'FFICallback' ].
	^ super phDeclarationWith: prefix
]
