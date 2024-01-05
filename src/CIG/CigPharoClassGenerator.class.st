Class {
	#name : 'CigPharoClassGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass',
		'classElement'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'instance creation' }
CigPharoClassGenerator class >> newFile: aLibraryGenerator class: aCigClass [ 
	
	^ self new 
		file: aLibraryGenerator;
		unit: aCigClass root;
		classElement: aCigClass;
		yourself
]

{ #category : 'as yet unclassified' }
CigPharoClassGenerator >> addClass [

	generatedClass := self baseObjectClass << self classElement phDeclaration asSymbol
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

{ #category : 'accessing' }
CigPharoClassGenerator >> classElement [

	^ classElement
]

{ #category : 'accessing' }
CigPharoClassGenerator >> classElement: aClass [

	classElement := aClass
]

{ #category : 'as yet unclassified' }
CigPharoClassGenerator >> disposeTemplate [
		
	^ String streamContents: [ :stream |
		stream << 'dispose'; cr.
		self classElement shouldExposeDispose ifTrue: [ 
			stream cr; tab.
			stream << 'self ffiCall: #(' << self classElement cDisposeTemplate generateHeader << ')' ] ]
]

{ #category : 'generating' }
CigPharoClassGenerator >> generate [

	self addClass.
	self addDisposeMethod
]

{ #category : 'private' }
CigPharoClassGenerator >> namespaceName [

	^ self defaultNamespaceName
]
