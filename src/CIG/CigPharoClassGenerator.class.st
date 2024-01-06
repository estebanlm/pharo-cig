Class {
	#name : 'CigPharoClassGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'as yet unclassified' }
CigPharoClassGenerator >> addClass [

	generatedClass := self baseObjectClass << self element phDeclaration asSymbol
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'as yet unclassified' }
CigPharoClassGenerator >> addDisposeMethod [

	generatedClass 
		compile: self disposeTemplate
		classified: 'finalizing' 
]

{ #category : 'as yet unclassified' }
CigPharoClassGenerator >> disposeTemplate [
		
	^ String streamContents: [ :stream |
		stream << 'dispose'; cr.
		self element shouldExposeDispose ifTrue: [ 
			stream cr; tab.
			stream << 'self ffiCall: #(' << self element cDisposeTemplate generateHeader << ')' ] ]
]

{ #category : 'generating' }
CigPharoClassGenerator >> generate [

	self addClass.
	self addDisposeMethod
]
