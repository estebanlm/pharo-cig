Class {
	#name : 'CigPharoConstructorGenerator',
	#superclass : 'CigPharoFunctionGenerator',
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private' }
CigPharoConstructorGenerator >> classForElement [
	| class |	
	
	class := self class environment classNamed: self element parent phDeclaration.
	^ class class
]

{ #category : 'as yet unclassified' }
CigPharoConstructorGenerator >> factoryMethodName [
	
	^ (String streamContents: [ :stream | 
			stream  <<  'new'.
			self element parameters ifNotEmpty: [ :params |
				params first in: [ :each | 
					stream << each name capitalized << ': ' << each name << ' ' ].
				params allButFirst do: [ :each | 
					stream << each name << ': ' << each name << ' ' ] ] ])
		trimmed
]

{ #category : 'as yet unclassified' }
CigPharoConstructorGenerator >> factoryMethodTemplate [
""
	^ String streamContents: [ :stream | 
		stream << self factoryMethodName; cr.
		stream cr; tab.
		stream << '^ (self ' << self element phTemplate generateHeader << ') initialize' ]
]

{ #category : 'generating' }
CigPharoConstructorGenerator >> generate [
	"so... we will first generate a private method for the real call to constructor, 
	 then a factory method to call it (along with 'initialize')"
	
	super generate.
	self generateFactoryMethod
]

{ #category : 'generating' }
CigPharoConstructorGenerator >> generateFactoryMethod [

	self classForElement
		compile: self factoryMethodTemplate
		classified: 'instance creation'
]

{ #category : 'as yet unclassified' }
CigPharoConstructorGenerator >> protocol [

	^ 'private'
]
