Class {
	#name : 'CigPharoBaseObjectClassGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private' }
CigPharoBaseObjectClassGenerator >> addClass [
	
	generatedClass := FFIOpaqueObject << self baseObjectClassName asSymbol
		traits: self libraryTrait;
		sharedPools: { #CigCPPTypedef. self libraryTypedefName asSymbol };
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'private' }
CigPharoBaseObjectClassGenerator >> addMethodAutoRelease [
	
	generatedClass 
		compile: 'autoRelease
	
	FinalizationRegistry default add: self'
		classified: 'finalization'
]

{ #category : 'private' }
CigPharoBaseObjectClassGenerator >> addMethodDispose [
	
	generatedClass 
		compile: 'dispose
	
	self subclassResponsibility'
		classified: 'finalization'
]

{ #category : 'private' }
CigPharoBaseObjectClassGenerator >> addMethodFinalize [
	
	generatedClass 
		compile: 'finalize
	
	self dispose.
	handle beNull'
		classified: 'finalization'
]

{ #category : 'private' }
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
