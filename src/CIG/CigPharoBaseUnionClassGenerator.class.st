Class {
	#name : 'CigPharoBaseUnionClassGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'as yet unclassified' }
CigPharoBaseUnionClassGenerator >> addUnion [
	
	generatedClass := FFIUnion << self baseUnionClassName asSymbol
		traits: self libraryTrait;
		sharedPools: { self libraryTypedefName asSymbol };
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'generating' }
CigPharoBaseUnionClassGenerator >> generate [

	self addUnion
]

{ #category : 'as yet unclassified' }
CigPharoBaseUnionClassGenerator >> namespaceName [

	^ self defaultNamespaceName
]
