Class {
	#name : 'CigPharoBaseStructureClassGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'private' }
CigPharoBaseStructureClassGenerator >> addStructure [
	
	generatedClass := FFIStructure << self baseStructureClassName asSymbol
		traits: self libraryTrait;
		sharedPools: { self libraryTypedefName asSymbol };
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