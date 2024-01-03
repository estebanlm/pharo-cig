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

{ #category : 'private' }
CigFunction >> buildParameters: aCollection on: stream [ 
	
	aCollection ifEmpty: [ ^ self ].
	
	aCollection first in: [ :each | 
		aCollection size > 1 
			ifTrue: [ stream << each name capitalized ].
		stream << ': ' << each name << ' ' ].
	aCollection allButFirst do: [ :each | 
		stream << each name << ': ' << each name << ' ' ]
]

{ #category : 'accessing' }
CigFunction >> cDeclaration [

	^ self disambiguate: super cDeclaration
]

{ #category : 'accessing' }
CigFunction >> cTemplate [
	
	^ CigCFunctionTemplate for: self
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
CigFunction >> returnTypeName [

	^ returnTypeName
]

{ #category : 'accessing' }
CigFunction >> spelling [

	^ spelling
]
