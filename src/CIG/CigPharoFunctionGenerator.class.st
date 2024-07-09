Class {
	#name : 'CigPharoFunctionGenerator',
	#superclass : 'CigPharoGenerator',
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private' }
CigPharoFunctionGenerator >> classForElement [
		
	^ self libraryClass
]

{ #category : 'generating' }
CigPharoFunctionGenerator >> generate [

	self classForElement
		compile: self element phTemplate generate
		classified: self protocol.
	self logInfo: [ '{1}>>{2} added.' format: { 
		self classForElement name.
		self element phDeclaration } ]
		
	
]

{ #category : 'generating' }
CigPharoFunctionGenerator >> generateOn: aVisitor [

	self generate.
	self element resolveReturnType isArray 
		ifTrue: [ self halt ].
	self element parameters 
		select: [ :each | each resolveType isArray ]
		thenDo: [ :each | self halt ]		
		
	
]

{ #category : 'private' }
CigPharoFunctionGenerator >> protocol [

	^ 'public'
]
