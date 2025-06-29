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
	| name |

	name := self nameForClass.
	logger trace: name.
	generatedClass := self baseClass << name
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'private' }
CigPharoClassGenerator >> addClassComment [

	self element hasComment ifFalse: [ ^ self ].
	generatedClass comment: self element comment
]

{ #category : 'private' }
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

	"ensuring I have a concrete name and not a template (it may arrive like 
	 that when creating a template specialization hierarchy)"
	^ self class environment classNamed: (aName copyUpTo: $<)
]

{ #category : 'private' }
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
	self element shouldExposeDispose
		ifTrue: [ self addDisposeMethod ].
	self addClassComment
]

{ #category : 'private' }
CigPharoClassGenerator >> nameForClass [
	
	^ element phDeclaration asSymbol
]
