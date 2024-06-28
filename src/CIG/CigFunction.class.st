Class {
	#name : 'CigFunction',
	#superclass : 'CigElement',
	#traits : 'CigTFunction',
	#classTraits : 'CigTFunction classTrait',
	#instVars : [
		'elaboratedSpec',
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
CigFunction >> cDeclaration [

	^ self disambiguateName: super cDeclaration
]

{ #category : 'accessing' }
CigFunction >> cTemplate [
	
	^ CigCFunctionTemplate for: self
]

{ #category : 'testing' }
CigFunction >> canBeExported [
	
	"skip operators because they are not really used in pharo. 
	 skip function with va_list because we don't know what to do with them.
	 skip functions with variadics (...) because we also can't forward them easily 
	 to its C++ counterpart (doable in gcc, but feels too much work for lose gain)"
	^ (self isOperator not)
		and: [ (self hasVariadicListArgument not)
		and: [ (self isVariadic not)
		and: [ (self parameters allSatisfy: [ :each | each canBeExported ])
		and: [ (self root isExcludedFromExport: self) not ] ] ] ]
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
CigFunction >> extractElaborated: aType [

	underlyingTypeName := aType spelling.
	underlyingTypeKind := aType kind.
	(underlyingTypeName indexOf: $<) > 0 ifTrue: [ 
		self 
			checkForTemplateSpecialization: aType 
			name: underlyingTypeName ]
]

{ #category : 'initialization' }
CigFunction >> extractElaboratedFromSpecializationTypes [

	specializationTypes isEmptyOrNil ifTrue: [ ^ self ].
	
	underlyingTypeName := returnTypeName.
	underlyingTypeKind := CXType_Unexposed
]

{ #category : 'initialization' }
CigFunction >> fromCursor: aCursor [
	| type |
	
	super fromCursor: aCursor.
	self fillFunctionWith: aCursor.
	type := aCursor type.
	type kind  = CXType_Elaborated 
		ifTrue: [ self extractElaborated: type namedType ]
		ifFalse: [ self extractElaboratedFromSpecializationTypes ]
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

{ #category : 'testing' }
CigFunction >> isTemplateSpecialization [

	^ elaboratedSpec 
		ifNotNil: [ elaboratedSpec isTemplateSpecialization ]
		ifNil: [ false ]
]

{ #category : 'accessing' }
CigFunction >> pathName [

	^ self spelling
]

{ #category : 'accessing' }
CigFunction >> phDeclaration [

	^ (String streamContents: [ :stream | 
			stream  << (self sanitizeName: self spelling).
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
CigFunction >> specializationTypes [

	^ elaboratedSpec ifNotNil: #specializationTypes
]

{ #category : 'accessing' }
CigFunction >> spelling [

	^ spelling
]
