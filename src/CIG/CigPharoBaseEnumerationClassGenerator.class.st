Class {
	#name : 'CigPharoBaseEnumerationClassGenerator',
	#superclass : 'CigPharoBaseClassGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'generating' }
CigPharoBaseEnumerationClassGenerator >> addEnum [
	
	generatedClass := FFIEnumeration << self baseEnumClassName asSymbol
		traits: self libraryTrait;
		sharedPools: self sharedPoolNames;
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'generating' }
CigPharoBaseEnumerationClassGenerator >> generate [

	self addEnum
]
