"
Visitor to generate Pharo side of bindings.
It starts in a unit, and it generates all needed to execute the library. 
"
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

	self addFFITypesClass: aUnit.
	self addFFILibrary: aUnit.
	self addFFITrait: aUnit
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

{ #category : 'visiting' }
CigPharoVisitor >> addVariadicDeclarations: aUnit [

	aUnit variadics ifNil: [ ^ self ].
	
	
]

{ #category : 'private' }
CigPharoVisitor >> disableRegisterChangesDuring: aBlock [
	| monitor |

	monitor := self class environment classNamed: #EpMonitor.
	monitor ifNil: [ ^ aBlock value ].
	
	^ monitor disableDuring: [ aBlock value ]
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

	"with apply of naming conventions, etc. It may happen that declaration now is 
	 equal to the type... we skip this."	
	aDeclaration = aString ifTrue: [ ^ self ].

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

	types := OrderedDictionary new.
	initializationRegistry := OrderedCollection new
]

{ #category : 'private' }
CigPharoVisitor >> types [

	^ types
]

{ #category : 'visiting' }
CigPharoVisitor >> visitClass: aClass [
	
	self ensureBaseObjectClass: aClass root.
	self flag: #TODO. "Maybe add accessors for fields? (style properties)"
	(CigPharoClassGenerator newFile: self file element: aClass) generateOn: self.
	super visitClass: aClass.
	self registerType: aClass
]

{ #category : 'visiting' }
CigPharoVisitor >> visitClassTemplate: aClassTemplate [
		
	"add a superclass (mostly empty)"
	self visitClass: aClassTemplate asBaseClass.
	"we add one subclass for each specialized type"
	aClassTemplate typeSpecializations do: [ :each |
		self visitClass: (aClassTemplate addSubclassWithSpecializedType: each) ]
]

{ #category : 'visiting' }
CigPharoVisitor >> visitConstructor: aConstructor [

	"abstract classes do not have public constructors"
	aConstructor parent isAbstract ifTrue: [ ^ self ].
	"we just want public constructors"
	aConstructor isPublic ifFalse: [ ^ self ].

	(CigPharoConstructorGenerator newFile: self file element: aConstructor) generateOn: self
]

{ #category : 'visiting' }
CigPharoVisitor >> visitEnum: anEnum [

	"skip if not public"
	anEnum isPublic ifFalse: [ ^ self ].
	"skip if not namec"
	(anEnum isAnonymous or: [ anEnum isUnnamed ]) ifTrue: [ ^ self ].

	self ensureBaseEnumerationClass: anEnum root.
	(CigPharoEnumGenerator newFile: self file element: anEnum) generateOn: self.
	self registerType: anEnum
]

{ #category : 'visiting' }
CigPharoVisitor >> visitFunction: aFunction [
	
	"skip operators because they are not used in pharo. 
	 skip function with va_list because we don't know what to do with them.
	 skip functions with variadics (...) because we also can't forward them easily 
	 to its C++ counterpart (doable in gcc, but feels too much work for lose gain)"
	(aFunction isOperator 
		or: [ aFunction hasVariadicListArgument
		or: [ aFunction isVariadic ] ])
		ifTrue: [ ^ self ].

	(CigPharoFunctionGenerator newFile: self file element: aFunction) generateOn: self
]

{ #category : 'visiting' }
CigPharoVisitor >> visitMethod: aMethod [

	(aMethod isPublic not 
		or: [ aMethod isOperator
		or: [ aMethod hasVariadicListArgument
		or: [ aMethod isVariadic ] ] ])
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

	aStructure canBeExported ifFalse: [ ^ self ].
	aStructure isClass
		ifTrue: [ ^ self visitClass: aStructure ].

	self ensureBaseStructureClass: aStructure root.
	self 
		visitStructure: aStructure 
		generator: CigPharoStructureGenerator
]

{ #category : 'visiting' }
CigPharoVisitor >> visitStructure: aStructure generator: generatorClass [
	| generator |
	
	(aStructure fieldAnonymousReferences, aStructure fieldInnerStructures)
		do: [ :each | each accept: self ].
	(generator := generatorClass newFile: self file element: aStructure) generateOn: self.
	self 
		registerDeclaration: aStructure cDeclaration 
		as: generator structName
]

{ #category : 'visiting' }
CigPharoVisitor >> visitTypedef: aTypedef [

	(aTypedef isPublic not 
		or: [ aTypedef isHomonym ]) 
		ifTrue: [ ^ self ].

	(CigPharoTypedefGenerator newFile: self file element: aTypedef) generateOn: self
]

{ #category : 'visiting' }
CigPharoVisitor >> visitUnion: aUnion [

	aUnion canBeExported ifFalse: [ ^ self ].
	aUnion isClass
		ifTrue: [ ^ self visitClass: aUnion ].
	
	self ensureBaseUnionClass: aUnion root.
	self 
		visitStructure: aUnion 
		generator: CigPharoUnionGenerator
]

{ #category : 'visiting' }
CigPharoVisitor >> visitUnit: aUnit [

	self reset.
	self disableRegisterChangesDuring: [ 
		self addBaseClasses: aUnit.
		self visitAll: aUnit elements.
		self addVariadicDeclarations: aUnit.
		self endUnit: aUnit ]
]
