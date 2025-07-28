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
	| name |

	name := self classForElement name asString, '>>', self element phDeclaration.
	logger trace: name.

	self classForElement
		compile: self element phTemplate generate
		classified: self protocol
]

{ #category : 'generating' }
CigPharoFunctionGenerator >> generateOn: aVisitor [

	self generate.
	"self element resolveReturnType isArray 
		ifTrue: [ self halt ].
	self element parameters 
		select: [ :each | each resolveType isArray ]
		thenDo: [ :each | self halt ]"
]

{ #category : 'private' }
CigPharoFunctionGenerator >> protocol [

	^ self element root nameGenerator visitFunctionProtocol: self element
]
