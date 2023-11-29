Class {
	#name : 'IGTypedefType',
	#superclass : 'IGType',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
IGTypedefType >> phDeclarationWith: prefix [

	parent definesFunction ifTrue: [ ^ 'FFICallback' ].
	^ super phDeclarationWith: prefix
]
