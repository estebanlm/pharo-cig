Class {
	#name : 'CigPharoStructureGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'as yet unclassified' }
CigPharoStructureGenerator >> addStruct [
	
	generatedClass := (self baseClass << self structName)
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'as yet unclassified' }
CigPharoStructureGenerator >> addStructFieldsDesc [
	
	generatedClass class 
		compile: self element phTemplate generateFieldsDesc
		classified: 'field definition'
]

{ #category : 'as yet unclassified' }
CigPharoStructureGenerator >> baseClass [

	^ self baseStructureClass
]

{ #category : 'generating' }
CigPharoStructureGenerator >> doInitialize [

	generatedClass rebuildFieldAccessors
]

{ #category : 'generating' }
CigPharoStructureGenerator >> generate [
	
	self addStruct.
	self addStructFieldsDesc
]

{ #category : 'generating' }
CigPharoStructureGenerator >> generateOn: aVisitor [
	
	super generateOn: aVisitor.
	aVisitor registerForInitialization: self
]

{ #category : 'as yet unclassified' }
CigPharoStructureGenerator >> structName [

	^ self element isAnonymous
		ifTrue: [ self element phTemplate anonymousTypeName ]
		ifFalse: [ self element phDeclaration ]
]
