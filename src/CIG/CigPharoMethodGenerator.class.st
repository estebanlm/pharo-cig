Class {
	#name : 'CigPharoMethodGenerator',
	#superclass : 'CigPharoFunctionGenerator',
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private' }
CigPharoMethodGenerator >> classForElement [
	| class |	
	
	class := self class environment classNamed: self element parent phDeclaration.
	^ self element isStatic
		ifTrue: [ class class ]
		ifFalse: [ class ]
]
