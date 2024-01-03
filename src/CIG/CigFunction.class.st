Class {
	#name : 'CigFunction',
	#superclass : 'CigElement',
	#traits : 'CigTFunction + CigTTemplateSpecialization',
	#classTraits : 'CigTFunction classTrait + CigTTemplateSpecialization classTrait',
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
CigFunction class >> kind [

	^ CXCursor_FunctionDecl
]

{ #category : 'visiting' }
CigFunction >> accept: aVisitor [

	aVisitor visitFunction: self
]

{ #category : 'accessing' }
CigFunction >> argumentsAsList [

	^ (self parameters collect: [ :each | each asArgumentString ]) asCommaString
]

{ #category : 'accessing' }
CigFunction >> cDeclaration [

	^ self disambiguate: super cDeclaration
]

{ #category : 'accessing' }
CigFunction >> cTemplate [
	
	^ CigCFunctionTemplate for: self
]

{ #category : 'testing' }
CigFunction >> exposesReturnValueAsParameter [
	| type |

	type := self resolveReturnType.
	^ type isClass 
		and: [ type isPointer not
		and: [ type element hasOperatorOverloadNewManyArguments ] ]
]

{ #category : 'initialization' }
CigFunction >> fromCursor: aCursor [
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
CigFunction >> hasComment [
	
	^ self comment isEmptyOrNil not
]

{ #category : 'testing' }
CigFunction >> isFunction [

	^ true
]

{ #category : 'testing' }
CigFunction >> isOperator [

	^ (self name beginsWith: 'operator') and: [
		  self name size > 8 and: [ (self name at: 9) isAlphaNumeric not ] ]
]

{ #category : 'testing' }
CigFunction >> isReturnTypeVoid [

	^ self returnTypeName = 'void'
]

{ #category : 'accessing' }
CigFunction >> pathName [

	^ self spelling
]

{ #category : 'accessing' }
CigFunction >> phDeclaration [

	^ (String streamContents: [ :stream | 
			stream  << self spelling uncapitalized.
			self buildParameters: self parameters on: stream ])
		trimmed
]

{ #category : 'accessing' }
CigFunction >> phTemplate [
	
	^ CigPharoFunctionTemplate for: self
]

{ #category : 'accessing' }
CigFunction >> returnTypeName [

	^ returnTypeName
]

{ #category : 'accessing' }
CigFunction >> spelling [

	^ spelling
]
