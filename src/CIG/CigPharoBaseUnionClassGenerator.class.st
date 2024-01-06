Class {
	#name : 'CigPharoBaseUnionClassGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'private' }
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

{ #category : 'private' }
CigPharoBaseUnionClassGenerator >> namespaceName [

	^ self defaultNamespaceName
]
