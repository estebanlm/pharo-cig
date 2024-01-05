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

{ #category : 'adding' }
CigPharoStructureGenerator >> addStruct [
	
	generatedClass := (self baseStructureClass << self struct phDeclaration)
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'adding' }
CigPharoStructureGenerator >> addStructFieldsDesc [
	
	generatedClass class 
		compile: self struct phTemplate generateFieldsDesc
		classified: 'enum declaration'
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
