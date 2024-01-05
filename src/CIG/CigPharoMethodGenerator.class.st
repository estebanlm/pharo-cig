Class {
	#name : 'CigPharoMethodGenerator',
	#superclass : 'CigPharoFunctionGenerator',
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'private' }
CigPharoMethodGenerator >> classForElement [
	| class |	
	
	class := self class environment classNamed: self function parent phDeclaration.
	^ self function isStatic
		ifTrue: [ class class ]
		ifFalse: [ class ]
]
