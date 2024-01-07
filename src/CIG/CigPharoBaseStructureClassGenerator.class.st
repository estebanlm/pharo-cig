Class {
	#name : 'CigPharoBaseStructureClassGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private' }
CigPharoBaseStructureClassGenerator >> addStructure [
	
	generatedClass := FFIStructure << self baseStructureClassName asSymbol
		traits: self libraryTrait;
		sharedPools: { #CigCPPTypedef. self libraryTypedefName asSymbol };
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'generating' }
CigPharoBaseStructureClassGenerator >> generate [

	self addStructure
]

{ #category : 'private' }
CigPharoBaseStructureClassGenerator >> namespaceName [

	^ self defaultNamespaceName
]
