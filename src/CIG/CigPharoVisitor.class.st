Class {
	#name : 'CigPharoVisitor',
	#superclass : 'CigVisitor',
	#instVars : [
		'types',
		'initializationRegistry'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'private' }
CigPharoVisitor >> addBaseClasses: aUnit [

	self addFFILibrary: aUnit.
	self addFFITrait: aUnit.
	self addFFITypesClass: aUnit
]

{ #category : 'private' }
CigPharoVisitor >> addDeclaredTypesToTypedef: aUnit [

	(CigPharoTypesPoolGenerator newFile: self file unit: aUnit) generateTypes: self types
]

{ #category : 'private' }
CigPharoVisitor >> addFFILibrary: aUnit [ 
	
	(CigPharoLibraryGenerator newFile: self file unit: aUnit) generate
]

{ #category : 'private' }
CigPharoVisitor >> addFFITrait: aUnit [

	(CigPharoTraitGenerator newFile: self file unit: aUnit) generate
]

{ #category : 'private' }
CigPharoVisitor >> addFFITypesClass: aUnit [
	
	(CigPharoTypesPoolGenerator newFile: self file unit: aUnit) generate
]

{ #category : 'private' }
CigPharoVisitor >> endUnit: aUnit [

	self addDeclaredTypesToTypedef: aUnit.
	self executeInitializations
]

{ #category : 'private' }
CigPharoVisitor >> ensureBaseEnumerationClass: aUnit [ 
	| generator |
	
	generator := CigPharoBaseEnumerationClassGenerator newFile: self file unit: aUnit.
	generator baseEnumClass ifNotNil: [ ^ self ].
	generator generate
]

{ #category : 'private' }
CigPharoVisitor >> ensureBaseObjectClass: aUnit [
	| generator |
	
	generator := CigPharoBaseObjectClassGenerator newFile: self file unit: aUnit.
	generator baseObjectClass ifNotNil: [ ^ self ].
	generator generate
]

{ #category : 'private' }
CigPharoVisitor >> ensureBaseStructureClass: aUnit [ 
	| generator |
	
	generator := CigPharoBaseStructureClassGenerator newFile: self file unit: aUnit.
	generator baseStructureClass ifNotNil: [ ^ self ].
	generator generate
]

{ #category : 'private' }
CigPharoVisitor >> ensureBaseUnionClass: aUnit [ 
	| generator |
	
	generator := CigPharoBaseUnionClassGenerator newFile: self file unit: aUnit.
	generator baseUnionClass ifNotNil: [ ^ self ].
	generator generate
]

{ #category : 'private' }
CigPharoVisitor >> executeInitializations [

	initializationRegistry do: [ :each | 
		each doInitialize ]
]

{ #category : 'private' }
CigPharoVisitor >> registerDeclaration: aDeclaration as: aString [

	types 
		at: ((aDeclaration endsWith: '*')
			ifTrue: [ aDeclaration allButLast ]
			ifFalse: [ aDeclaration ])
		put: aString
]

{ #category : 'private' }
CigPharoVisitor >> registerForInitialization: aGenerator [

	initializationRegistry add: aGenerator
]

{ #category : 'private' }
CigPharoVisitor >> registerType: anElement [

	self 
		registerDeclaration: anElement cDeclaration 
		as: anElement phDeclaration
]

{ #category : 'private' }
CigPharoVisitor >> reset [

	types := Dictionary new.
	initializationRegistry := OrderedCollection new
]

{ #category : 'private' }
CigPharoVisitor >> types [

	^ types
]

{ #category : 'visiting' }
CigPharoVisitor >> visitClass: aClass [
	
	self ensureBaseObjectClass: aClass root.
	(CigPharoClassGenerator newFile: self file element: aClass) generateOn: self.
	super visitClass: aClass.
	self registerType: aClass
]

{ #category : 'visiting' }
CigPharoVisitor >> visitClassTemplate: aClassTemplate [
		
	self visitClass: aClassTemplate asBaseClass.
	"we add one subclass for each specialized type"
	aClassTemplate typeSpecializations do: [ :each |
		self visitClass: (aClassTemplate addSubclassWithSpecializedType: each) ]
]

{ #category : 'visiting' }
CigPharoVisitor >> visitConstructor: aConstructor [

	(CigPharoConstructorGenerator newFile: self file element: aConstructor) generateOn: self
]

{ #category : 'visiting' }
CigPharoVisitor >> visitEnum: anEnum [

	self ensureBaseEnumerationClass: anEnum root.
	(CigPharoEnumGenerator newFile: self file element: anEnum) generateOn: self.
	self registerType: anEnum
]

{ #category : 'visiting' }
CigPharoVisitor >> visitFunction: aFunction [
	
	(CigPharoFunctionGenerator newFile: self file element: aFunction) generateOn: self
]

{ #category : 'visiting' }
CigPharoVisitor >> visitMethod: aMethod [

	(aMethod isPublic not 
		or: [ aMethod isOperator ]) 
		ifTrue: [ ^ self ].

	(CigPharoMethodGenerator newFile: self file element: aMethod) generateOn: self
]

{ #category : 'visiting' }
CigPharoVisitor >> visitNamespace: aNamespace [

	(self includesNamespace: aNamespace cppDeclaration) ifTrue: [
		self visitAll: (aNamespace elements select: [ :each | each isNamespace ]). 
		 ^ self ].

	(CigPharoNamespaceGenerator newFile: self file element: aNamespace) generateOn: self.
	self visitAll: aNamespace elements
]

{ #category : 'visiting' }
CigPharoVisitor >> visitStructure: aStructure [
	
	self ensureBaseStructureClass: aStructure root.
	aStructure fieldAnonymousReferences 
		do: [ :each | each accept: self ].
	(CigPharoStructureGenerator newFile: self file element: aStructure) generateOn: self.
	self registerType: aStructure
]

{ #category : 'visiting' }
CigPharoVisitor >> visitTypedef: aTypedef [
	
	(CigPharoTypedefGenerator newFile: self file element: aTypedef) generateOn: self
]

{ #category : 'visiting' }
CigPharoVisitor >> visitUnion: anUnion [
	| generator |
	
	self ensureBaseUnionClass: anUnion root.
	anUnion fieldAnonymousReferences 
		do: [ :each | each accept: self ].
	(generator := CigPharoUnionGenerator newFile: self file element: anUnion) generateOn: self
]

{ #category : 'visiting' }
CigPharoVisitor >> visitUnit: aUnit [

	self reset.
	self addBaseClasses: aUnit.
	self visitAll: aUnit elements.
	self endUnit: aUnit
]
