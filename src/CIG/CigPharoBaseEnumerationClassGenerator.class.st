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

{ #category : 'private' }
CigPharoBaseEnumerationClassGenerator >> addEnum [
	
	generatedClass := FFIEnumeration << self baseEnumClassName asSymbol
		traits: self libraryTrait;
		sharedPools: { #CigCPPTypedef. self libraryTypedefName asSymbol };
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'generating' }
CigPharoBaseEnumerationClassGenerator >> generate [

	self addEnum
]

{ #category : 'private' }
CigPharoBaseEnumerationClassGenerator >> namespaceName [

	^ self defaultNamespaceName
]
