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

{ #category : 'private' }
CigPharoClassGenerator >> addClass [

	generatedClass := self baseClass << self nameForClass
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

{ #category : 'private' }
CigPharoClassGenerator >> baseClass [
	| superclass |

	superclass := self element superclass ifNil: [ ^ self baseObjectClass ].
	^ superclass reference 
		ifNotNil: [ :anElement | self classFor: anElement phDeclaration ]
		ifNil: [ self baseObjectClass ]
]

{ #category : 'private' }
CigPharoClassGenerator >> classFor: aName [

	^ self class environment classNamed: aName
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

{ #category : 'private' }
CigPharoClassGenerator >> nameForClass [
	
	^ element phDeclaration asSymbol
]
