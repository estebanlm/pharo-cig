Class {
	#name : 'CigPharoEnumGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'as yet unclassified' }
CigPharoEnumGenerator >> addEnum [
	
	generatedClass := (self baseEnumClass << self element phDeclaration)
		sharedPools: { self libraryTypedefName asSymbol };
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'as yet unclassified' }
CigPharoEnumGenerator >> addEnumDecl [
	
	generatedClass class 
		compile: self element phTemplate generateEnumDecl
		classified: 'enum declaration'
]

{ #category : 'generating' }
CigPharoEnumGenerator >> generate [
	
	self addEnum.
	self addEnumDecl
]
