Class {
	#name : 'CigPharoBaseEnumerationClassGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'as yet unclassified' }
CigPharoBaseEnumerationClassGenerator >> addEnum [
	
	generatedClass := FFIEnumeration << self baseEnumClassName asSymbol
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
