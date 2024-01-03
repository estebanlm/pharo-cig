Class {
	#name : 'CigClassMember',
	#superclass : 'CigElement',
	#traits : 'CigTFunction + CigTTemplateSpecialization',
	#classTraits : 'CigTFunction classTrait + CigTTemplateSpecialization classTrait',
	#instVars : [
		'underlyingTypeName',
		'underlyingTypeKind',
		'isPublic'
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
CigClassMember >> asSpecializationOf: aClassTemplate type: typeString [
	
	^ self copy 
		specializeClassTemplate: aClassTemplate type: typeString;
		yourself
]

{ #category : 'private' }
CigClassMember >> buildParameters: aCollection on: stream [ 
	
	aCollection ifEmpty: [ ^ self ].
	
	aCollection first in: [ :each | 
		aCollection size > 1 
			ifTrue: [ stream << each name capitalized ].
		stream << ': ' << each name << ' ' ].
	aCollection allButFirst do: [ :each | 
		stream << each name << ': ' << each name << ' ' ]
]

{ #category : 'initialization' }
CigClassMember >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	self fillFunctionWith: aCursor.
	isPublic := aCursor cxxAccessSpecifier = 1.
	
	type := aCursor type.
	type kind  = CXType_Elaborated ifTrue: [ 
		| underlyingType |
		underlyingType :=  type namedType.
		underlyingTypeName := underlyingType spelling.
		underlyingTypeKind := underlyingType kind.
		(underlyingTypeName indexOf: $<) > 0 
			ifTrue: [ self checkForTemplateSpecialization: underlyingType ] ]
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
CigClassMember >> isClassMember [

	^ true
]

{ #category : 'testing' }
CigClassMember >> isConstructor [

	^ false
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

	^ isPublic and: [ 
		self parameters noneSatisfy: [ :each | each isDeclType ] ]
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
CigClassMember >> specializeClassTemplate: aClassTemplate type: typeString [

	self specializeTypeTemplate: aClassTemplate type: typeString.
	self specializeTypeClassTemplate: aClassTemplate type: typeString.

	parameters := self parameters collect: [ :each |
		(each isTemplateOf: aClassTemplate)
			ifTrue: [ 
				each copy
					specializeClassTemplate: aClassTemplate 
					type: typeString ]
			ifFalse: [ 
				each copy ] ]
]

{ #category : 'private' }
CigClassMember >> specializeTypeClassTemplate: aClassTemplate type: typeString [

	(self isReturnTypeClassTemplateOf: aClassTemplate) ifFalse: [ ^ self ]. 
	
	returnTypeName := CigType
		replaceTypeClassTemplate: aClassTemplate
		type: typeString
		in: returnTypeName.

	self typeReference ifNotNil: [ :aTypeReference |
		aTypeReference specializeTypeClassTemplate: aClassTemplate type: typeString ]
]

{ #category : 'private' }
CigClassMember >> specializeTypeTemplate: aClassTemplate type: typeString [
		
	(self isReturnTypeTemplateOf: aClassTemplate) ifFalse: [ ^ self ].
	 
	returnTypeName := CigType 
		replaceTypeTemplate: aClassTemplate
		type: typeString
		in: returnTypeName.
		
	self typeReference ifNotNil: [ :aTypeReference |
		aTypeReference specializeTypeTemplate: aClassTemplate type: typeString ]
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
