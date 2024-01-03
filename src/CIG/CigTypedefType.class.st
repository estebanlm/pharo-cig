Class {
	#name : 'CigTypedefType',
	#superclass : 'CigType',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigTypedefType >> phDeclarationWith: prefix [

	parent definesFunction ifTrue: [ ^ 'FFICallback' ].
	^ super phDeclarationWith: prefix
]
