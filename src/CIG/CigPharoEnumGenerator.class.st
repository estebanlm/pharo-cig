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

{ #category : 'private' }
CigPharoEnumGenerator >> addEnum [
	| name |
	name := self element phDeclaration.
	generatedClass := (self baseEnumClass << name)
		tag: self namespaceName;
		package: self packageName;
		install.
	self logInfo: [ 'Enum {1} added.' format: { name } ]
]

{ #category : 'private' }
CigPharoEnumGenerator >> addEnumDecl [

	generatedClass class 
		compile: self element phTemplate generateEnumDecl
		classified: 'enum declaration'
]

{ #category : 'generating' }
CigPharoEnumGenerator >> doInitialize [

	generatedClass
		initializeEnumeration;
		rebuildEnumAccessors
]

{ #category : 'generating' }
CigPharoEnumGenerator >> generate [
	
	self addEnum.
	self addEnumDecl
]

{ #category : 'generating' }
CigPharoEnumGenerator >> generateOn: aVisitor [
	
	super generateOn: aVisitor.
	aVisitor registerForInitialization: self
]
