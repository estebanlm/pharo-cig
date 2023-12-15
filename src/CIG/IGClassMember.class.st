Class {
	#name : 'IGClassMember',
	#superclass : 'IGElement',
	#traits : 'IGTFunction + IGTTemplateSpecialization',
	#classTraits : 'IGTFunction classTrait + IGTTemplateSpecialization classTrait',
	#instVars : [
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
IGClassMember class >> kind [
	
	^ nil
]

{ #category : 'accessing' }
IGClassMember >> argumentsAsList [

	^ (self parameters collect: [ :each | each asArgumentString ]) asCommaString
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
IGClassMember >> isClassMember [

	^ true
]

{ #category : 'testing' }
IGClassMember >> isOperator [

	^ (self name beginsWith: 'operator') and: [
		  self name size > 8 and: [ (self name at: 9) isAlphaNumeric not ] ]
]

{ #category : 'testing' }
IGClassMember >> isReturnTypeVoid [

	^ self returnTypeName = 'void'
]

{ #category : 'accessing' }
IGClassMember >> parametersAsList [

	^ (self parameters collect: [ :each | each asParameterString ]) asCommaString
]

{ #category : 'accessing' }
IGClassMember >> pathName [

	^ self spelling
]

{ #category : 'handling' }
IGClassMember >> resolveReturnType [

	self isReturnTypeVoid ifTrue: [ ^ nil ].
	
	^ IGType new
		parent: self;
		name: self returnTypeName;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
IGClassMember >> returnTypeName [

	^ returnTypeName
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
