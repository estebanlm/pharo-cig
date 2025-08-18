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

{ #category : 'accessing' }
CigPharoStructureGenerator class >> structType [

	^ 'Struct'
]

{ #category : 'private' }
CigPharoStructureGenerator >> addStruct [
	| name |
	
	name := self structName.
	logger trace: name.
	
	generatedClass := (self baseClass << name)
		tag: self namespaceName;
		package: self packageName;
		install
]

{ #category : 'private' }
CigPharoStructureGenerator >> addStructFieldsDesc [
	
	generatedClass class 
		compile: self element phTemplate generateFieldsDesc
		classified: 'field definition'
]

{ #category : 'private' }
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
	aVisitor registerForInitialization: self.
	self element fields 
		select: [ :each | each isArray ]
		thenDo: [ :each |
			aVisitor
				registerDeclaration: each cTemplate generateFFIType
				as: (self nameForArrayType: each resolveType) ]
]

{ #category : 'generating' }
CigPharoStructureGenerator >> nameForArrayType: aType [
	"The problem is anonymous types that cannot be solved just like that in arrays.
	 To be able to map them, I need to solve first the name that will adopt in system, 
	 then add the array part"
	| typeName |

	typeName := aType name.

	aType hasElement ifFalse: [ ^ typeName ].
	aType element isStructure ifFalse: [ ^ typeName ].
	aType element isAnonymous ifFalse: [ ^ typeName ].

	^ aType element phTemplate anonymousTypeName, (typeName copyFrom: (typeName indexOf: $[) to: typeName size)
]

{ #category : 'accessing' }
CigPharoStructureGenerator >> structName [

	^ self element isAnonymous
		ifTrue: [ self element phTemplate anonymousTypeName ]
		ifFalse: [ self element phDeclaration ]
]
