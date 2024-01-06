Class {
	#name : 'CigPharoStructureGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass',
		'struct'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'instance creation' }
CigPharoStructureGenerator class >> newFile: aLibraryGenerator enum: anEnum [ 
	
	^ self new
		file: aLibraryGenerator;
		unit: anEnum root;
		enum: anEnum;
		yourself
]

{ #category : 'instance creation' }
CigPharoStructureGenerator class >> newFile: aLibraryGenerator struct: aStructure [ 
	
	^ self new 
		file: aLibraryGenerator;
		unit: aStructure root;
		struct: aStructure;
		yourself
]

{ #category : 'private' }
CigPharoStructureGenerator >> addStruct [
	
	generatedClass := (self baseClass << self structName)
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'private' }
CigPharoStructureGenerator >> addStructFieldsDesc [
	
	generatedClass class 
		compile: self struct phTemplate generateFieldsDesc
		classified: 'enum declaration'
]

{ #category : 'private' }
CigPharoStructureGenerator >> baseClass [

	^ self baseStructureClass
]

{ #category : 'generating' }
CigPharoStructureGenerator >> generate [
	
	self addStruct.
	self addStructFieldsDesc
]

{ #category : 'private' }
CigPharoStructureGenerator >> namespaceName [
	
	^ self defaultNamespaceName
]

{ #category : 'accessing' }
CigPharoStructureGenerator >> struct [

	^ struct
]

{ #category : 'accessing' }
CigPharoStructureGenerator >> struct: aStructure [ 
	
	struct := aStructure
]

{ #category : 'private' }
CigPharoStructureGenerator >> structName [

	^ self struct isAnonymous
		ifTrue: [ self struct phTemplate anonymousTypeName ]
		ifFalse: [ self struct phDeclaration ]
]
