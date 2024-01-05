Class {
	#name : 'CigPharoEnumGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'enum',
		'generatedClass'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'instance creation' }
CigPharoEnumGenerator class >> newFile: aLibraryGenerator enum: anEnum [ 
	
	^ self new
		file: aLibraryGenerator;
		unit: anEnum root;
		enum: anEnum;
		yourself
]

{ #category : 'as yet unclassified' }
CigPharoEnumGenerator >> addEnum [
	
	generatedClass := (self baseEnumClass << self enum phDeclaration)
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'as yet unclassified' }
CigPharoEnumGenerator >> addEnumDecl [
	
	generatedClass class 
		compile: self enum phTemplate generateEnumDecl
		classified: 'enum declaration'
]

{ #category : 'as yet unclassified' }
CigPharoEnumGenerator >> enum [

	^ enum
]

{ #category : 'as yet unclassified' }
CigPharoEnumGenerator >> enum: anEnum [

	enum := anEnum
]

{ #category : 'generating' }
CigPharoEnumGenerator >> generate [
	
	self addEnum.
	self addEnumDecl.
	
	generatedClass 
		initializeEnumeration;
		rebuildEnumAccessors
]

{ #category : 'private' }
CigPharoEnumGenerator >> namespaceName [
	
	^ self defaultNamespaceName
]
