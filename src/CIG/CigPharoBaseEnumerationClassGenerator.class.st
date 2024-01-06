Class {
	#name : 'CigPharoBaseEnumerationClassGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'as yet unclassified' }
CigPharoBaseEnumerationClassGenerator >> addEnum [
	
	generatedClass := FFIEnumeration << self baseEnumClassName asSymbol
		traits: self libraryTrait;
		sharedPools: { self libraryTypedefName asSymbol };
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'generating' }
CigPharoBaseEnumerationClassGenerator >> generate [

	self addEnum
]

{ #category : 'as yet unclassified' }
CigPharoBaseEnumerationClassGenerator >> namespaceName [

	^ self defaultNamespaceName
]
