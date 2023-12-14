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
		ifTrue: [ ^ (IGFunctionParser parse: parent underlyingTypeSpelling) name, '*'  ].

	^ parent underlyingTypeSpelling
]

{ #category : 'accessing' }
IGTypedefType >> phDeclarationWith: prefix [

	parent definesFunction ifTrue: [ ^ 'FFICallback' ].
	^ super phDeclarationWith: prefix
]
