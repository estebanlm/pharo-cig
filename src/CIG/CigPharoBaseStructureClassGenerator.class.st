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

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
CigPharoBaseStructureClassGenerator >> namespaceName [

	^ self defaultNamespaceName
]
