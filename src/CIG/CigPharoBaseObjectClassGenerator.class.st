Class {
	#name : 'CigPharoBaseObjectClassGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'as yet unclassified' }
CigPharoBaseObjectClassGenerator >> addClass [
	
	generatedClass := FFIOpaqueObject << self baseObjectClassName asSymbol
		traits: self libraryTrait;
		sharedPools: { self libraryTypedefName asSymbol };
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'as yet unclassified' }
CigPharoBaseObjectClassGenerator >> addMethodAutoRelease [
	
	generatedClass 
		compile: 'autoRelease
	
	FinalizationRegistry default add: self'
		classified: 'finalization'
]

{ #category : 'as yet unclassified' }
CigPharoBaseObjectClassGenerator >> addMethodDispose [
	
	generatedClass 
		compile: 'dispose
	
	self subclassResponsibility'
		classified: 'finalization'
]

{ #category : 'as yet unclassified' }
CigPharoBaseObjectClassGenerator >> addMethodFinalize [
	
	generatedClass 
		compile: 'finalize
	
	self dispose.
	handle beNull'
		classified: 'finalization'
]

{ #category : 'as yet unclassified' }
CigPharoBaseObjectClassGenerator >> addMethodInitialize [
	
	generatedClass 
		compile: 'initialize
	"do nothing (prevent initialize to set the handle)"'
		classified: 'initialization'
]

{ #category : 'generating' }
CigPharoBaseObjectClassGenerator >> generate [

	self addClass.
	self addMethodInitialize.
	self addMethodFinalize.
	self addMethodAutoRelease.
	self addMethodDispose
]

{ #category : 'private' }
CigPharoBaseObjectClassGenerator >> namespaceName [

	^ self defaultNamespaceName
]
