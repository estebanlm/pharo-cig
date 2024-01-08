Class {
	#name : 'CigPharoBaseStructureClassGenerator',
	#superclass : 'CigPharoBaseClassGenerator',
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
		sharedPools: self sharedPoolNames;
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'generating' }
CigPharoBaseStructureClassGenerator >> generate [

	self addStructure
]
