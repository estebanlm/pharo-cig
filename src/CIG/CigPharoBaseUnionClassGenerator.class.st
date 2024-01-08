Class {
	#name : 'CigPharoBaseUnionClassGenerator',
	#superclass : 'CigPharoBaseClassGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private' }
CigPharoBaseUnionClassGenerator >> addUnion [
	
	generatedClass := FFIUnion << self baseUnionClassName asSymbol
		traits: self libraryTrait;
		sharedPools: self sharedPoolNames;
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'generating' }
CigPharoBaseUnionClassGenerator >> generate [

	self addUnion
]
