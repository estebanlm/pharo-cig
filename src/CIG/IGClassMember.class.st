Class {
	#name : 'IGClassMember',
	#superclass : 'IGElement',
	#traits : 'IGTFunction + IGTTemplateSpecialization',
	#classTraits : 'IGTFunction classTrait + IGTTemplateSpecialization classTrait',
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
IGClassMember class >> kind [
	
	^ nil
]

{ #category : 'converting' }
IGClassMember >> asSpecializationOf: aClassTemplate type: typeString [
	
	^ self copy 
		specializeClassTemplate: aClassTemplate type: typeString;
		yourself
]

{ #category : 'private' }
IGClassMember >> buildParameters: aCollection on: stream [ 
	
	aCollection ifEmpty: [ ^ self ].
	
	aCollection first in: [ :each | 
		aCollection size > 1 
			ifTrue: [ stream << each name capitalized ].
		stream << ': ' << each name << ' ' ].
	aCollection allButFirst do: [ :each | 
		stream << each name << ': ' << each name << ' ' ]
]

{ #category : 'initialization' }
IGClassMember >> fromCursor: aCursor [
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
IGClassMember >> hasAnyParameterTypeClassTemplateOf: aClassTemplate [
	
	^ self parameters anySatisfy: [ :each | each isClassTemplateOf: aClassTemplate ]
]

{ #category : 'testing' }
IGClassMember >> hasAnyParameterTypeTemplateOf: aClassTemplate [
	
	^ self parameters anySatisfy: [ :each | each isTemplateOf: aClassTemplate ]
]

{ #category : 'testing' }
IGClassMember >> isClassMember [

	^ true
]

{ #category : 'testing' }
IGClassMember >> isConstructor [

	^ false
]

{ #category : 'testing' }
IGClassMember >> isDestructor [

	^ false
]

{ #category : 'testing' }
IGClassMember >> isOperator [

	^ (self name beginsWith: 'operator') and: [
		  self name size > 8 and: [ (self name at: 9) isAlphaNumeric not ] ]
]

{ #category : 'testing' }
IGClassMember >> isPublic [

	^ isPublic
]

{ #category : 'testing' }
IGClassMember >> isReturnTypeClassTemplateOf: aClassTemplate [
	
	^self returnTypeName includesSubstring: aClassTemplate name
]

{ #category : 'testing' }
IGClassMember >> isReturnTypeTemplateOf: aClassTemplate [
	
	^ aClassTemplate templateTypeParameters 
		anySatisfy: [ :each | each name = self resolveReturnType parseType name ]
]

{ #category : 'testing' }
IGClassMember >> isStatic [

	^ false
]

{ #category : 'testing' }
IGClassMember >> isTemplateOf: aClassTemplate [

	^ (self isReturnTypeTemplateOf: aClassTemplate)
		or: [ (self hasAnyParameterTypeTemplateOf: aClassTemplate)
		or: [ (self isReturnTypeClassTemplateOf: aClassTemplate) 
		or: [ self hasAnyParameterTypeClassTemplateOf: aClassTemplate ] ] ]
]

{ #category : 'accessing' }
IGClassMember >> parametersAsList [

	^ (self parameters collect: [ :each | each asParameterString ]) asCommaString
]

{ #category : 'accessing' }
IGClassMember >> pathName [

	^ self spelling
]

{ #category : 'accessing' }
IGClassMember >> returnTypeName [

	^ returnTypeName
]

{ #category : 'private' }
IGClassMember >> specializeClassTemplate: aClassTemplate type: typeString [
		
	(self isReturnTypeTemplateOf: aClassTemplate) ifTrue: [ 
		returnTypeName := IGType 
			replaceTypeTemplate: aClassTemplate
			type: typeString
			in: returnTypeName ].
	(self isReturnTypeClassTemplateOf: aClassTemplate) ifTrue: [ 
		returnTypeName := IGType 
			replaceTypeClassTemplate: aClassTemplate
			type: typeString
			in: returnTypeName ].

	parameters := self parameters collect: [ :each |
		(each isTemplateOf: aClassTemplate)
			ifTrue: [ 
				each copy 
					specializeClassTemplate: aClassTemplate 
					type: typeString ]
			ifFalse: [ 
				each copy ] ]
]

{ #category : 'accessing' }
IGClassMember >> spelling [

	^ spelling
]

{ #category : 'accessing' }
IGClassMember >> underlyingTypeKind [

	^ underlyingTypeKind
]

{ #category : 'accessing' }
IGClassMember >> underlyingTypeName [

	^ underlyingTypeName
]
