Class {
	#name : 'CigPharoConstructorGenerator',
	#superclass : 'CigPharoFunctionGenerator',
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'private' }
CigPharoConstructorGenerator >> classForElement [
	| class |	
	
	class := self class environment classNamed: self function parent phDeclaration.
	^ class class
]

{ #category : 'private' }
CigPharoConstructorGenerator >> factoryMethodName [
	
	^ (String streamContents: [ :stream | 
			stream  <<  'new'.
			self function parameters ifNotEmpty: [ :params |
				params first in: [ :each | 
					stream << each name capitalized << ': ' << each name << ' ' ].
				params allButFirst do: [ :each | 
					stream << each name << ': ' << each name << ' ' ] ] ])
		trimmed
]

{ #category : 'private' }
CigPharoConstructorGenerator >> factoryMethodTemplate [
""
	^ String streamContents: [ :stream | 
		stream << self factoryMethodName; cr.
		stream cr; tab.
		stream << '^ (self ' << self function phTemplate generateHeader << ') initialize' ]
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

{ #category : 'private' }
CigPharoConstructorGenerator >> protocol [

	^ 'private'
]
