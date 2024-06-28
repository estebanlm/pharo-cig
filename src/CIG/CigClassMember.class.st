Class {
	#name : 'CigClassMember',
	#superclass : 'CigElement',
	#traits : 'CigTFunction',
	#classTraits : 'CigTFunction classTrait',
	#instVars : [
		'isPublic',
		'isDeleted',
		'underlyingTypeName',
		'underlyingTypeKind'
	],
	#pools : [
		'CXTypeKind'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigClassMember class >> kind [
	
	^ nil
]

{ #category : 'converting' }
CigClassMember >> asSpecializationOf: aClassTemplate types: aCollection [

	^ self copy 
		specializeClassTemplate: aClassTemplate types: aCollection;
		yourself
]

{ #category : 'testing' }
CigClassMember >> canBeExported [

	^ self isPublic
		and: [ (self isOperator not)
		and: [ (self hasVariadicListArgument not)
		and: [ (self isVariadic not)
		and: [ (self isDeleted not)
		and: [ (self parameters allSatisfy: [ :each | each canBeExported ])
		and: [ (self root isExcludedFromExport: self) not ] ] ] ] ] ]
]

{ #category : 'testing' }
CigClassMember >> exposesReturnValueAsParameter [

	^ false
]

{ #category : 'initialization' }
CigClassMember >> extractElaborated: aType [ 

	underlyingTypeName := aType spelling.
	underlyingTypeKind := aType kind.
	(underlyingTypeName indexOf: $<) > 0 ifTrue: [ 
		self 
			checkForTemplateSpecialization: aType 
			name: underlyingTypeName ]
]

{ #category : 'initialization' }
CigClassMember >> extractElaboratedFromSpecializationTypes [

	specializationTypes isEmptyOrNil ifTrue: [ ^ self ].
	
	underlyingTypeName := returnTypeName.
	underlyingTypeKind := CXType_Unexposed
]

{ #category : 'initialization' }
CigClassMember >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	self fillFunctionWith: aCursor.
	isPublic := aCursor cxxAccessSpecifier = 1.
	isDeleted := aCursor cxxMethodIsDeleted.
	
	type := aCursor type.
	type kind  = CXType_Elaborated 
		ifTrue: [ self extractElaborated: type namedType ]
		ifFalse: [ self extractElaboratedFromSpecializationTypes  ]
]

{ #category : 'testing' }
CigClassMember >> hasAnyParameterTypeClassTemplateOf: aClassTemplate [
	
	^ self parameters anySatisfy: [ :each | each isClassTemplateOf: aClassTemplate ]
]

{ #category : 'testing' }
CigClassMember >> hasAnyParameterTypeTemplateOf: aClassTemplate [
	
	^ self parameters anySatisfy: [ :each | each isTemplateOf: aClassTemplate ]
]

{ #category : 'testing' }
CigClassMember >> hasComment [
	
	^ self comment isEmptyOrNil not
]

{ #category : 'testing' }
CigClassMember >> isClassMember [

	^ true
]

{ #category : 'testing' }
CigClassMember >> isConstructor [

	^ false
]

{ #category : 'testing' }
CigClassMember >> isDeleted [

	^ isDeleted
]

{ #category : 'testing' }
CigClassMember >> isDestructor [

	^ false
]

{ #category : 'testing' }
CigClassMember >> isOperator [

	^ (self name beginsWith: 'operator') and: [
		  self name size > 8 and: [ (self name at: 9) isAlphaNumeric not ] ]
]

{ #category : 'testing' }
CigClassMember >> isPublic [

	^ (self parent isPublic: self)
		and: [ self parameters noneSatisfy: [ :each | each isDeclType ] ]
]

{ #category : 'testing' }
CigClassMember >> isReturnTypeClassTemplateOf: aClassTemplate [
	
	^self returnTypeName includesSubstring: aClassTemplate name
]

{ #category : 'testing' }
CigClassMember >> isReturnTypeTemplateOf: aClassTemplate [
	
	^ aClassTemplate templateTypeParameters 
		anySatisfy: [ :each | each name = self resolveReturnType parseType name ]
]

{ #category : 'testing' }
CigClassMember >> isStatic [

	^ false
]

{ #category : 'testing' }
CigClassMember >> isTemplateOf: aClassTemplate [

	^ (self isReturnTypeTemplateOf: aClassTemplate)
		or: [ (self hasAnyParameterTypeTemplateOf: aClassTemplate)
		or: [ (self isReturnTypeClassTemplateOf: aClassTemplate) 
		or: [ self hasAnyParameterTypeClassTemplateOf: aClassTemplate ] ] ]
]

{ #category : 'accessing' }
CigClassMember >> parametersAsList [

	^ (self parameters collect: [ :each | each asParameterString ]) asCommaString
]

{ #category : 'accessing' }
CigClassMember >> pathName [

	^ self spelling
]

{ #category : 'accessing' }
CigClassMember >> phTemplate [
	
	^ CigPharoFunctionTemplate for: self
]

{ #category : 'copying' }
CigClassMember >> postCopy [

	elements ifNil: [ ^ self ].
	elements := elements collect: [ :each | each copy ]
]

{ #category : 'accessing' }
CigClassMember >> returnTypeName [

	^ returnTypeName
]

{ #category : 'private' }
CigClassMember >> specializeClassTemplate: aClassTemplate types: aCollection [

	self specializeTypeTemplate: aClassTemplate types: aCollection.
	self specializeTypeClassTemplate: aClassTemplate types: aCollection.

	parameters := self parameters collect: [ :each |
		(each isTemplateOf: aClassTemplate)
			ifTrue: [ 
				each copy
					specializeClassTemplate: aClassTemplate 
					types: aCollection ]
			ifFalse: [ 
				each copy ] ]
]

{ #category : 'private' }
CigClassMember >> specializeTypeClassTemplate: aClassTemplate types: aCollection [

	(self isReturnTypeClassTemplateOf: aClassTemplate) ifFalse: [ ^ self ]. 
	
	returnTypeName := CigType
		replaceTypeClassTemplate: aClassTemplate
		types: aCollection
		in: returnTypeName.

	self typeReference ifNotNil: [ :aTypeReference |
		aTypeReference specializeTypeClassTemplate: aClassTemplate types: aCollection ]
]

{ #category : 'private' }
CigClassMember >> specializeTypeTemplate: aClassTemplate types: aCollection [
		
	(self isReturnTypeTemplateOf: aClassTemplate) ifFalse: [ ^ self ].
	 
	returnTypeName := CigType 
		replaceTypeTemplate: aClassTemplate
		types: aCollection
		in: returnTypeName.
		
	self typeReference ifNotNil: [ :aTypeReference |
		aTypeReference specializeTypeTemplate: aClassTemplate types: aCollection ]
]

{ #category : 'accessing' }
CigClassMember >> spelling [

	^ spelling
]

{ #category : 'accessing' }
CigClassMember >> underlyingTypeKind [

	^ underlyingTypeKind
]

{ #category : 'accessing' }
CigClassMember >> underlyingTypeName [

	^ underlyingTypeName
]
