Class {
	#name : 'IGParameter',
	#superclass : 'IGElement',
	#traits : 'IGTTemplateSpecialization',
	#classTraits : 'IGTTemplateSpecialization classTrait',
	#instVars : [
		'typeName',
		'typeKind',
		'templateTypes',
		'underlyingTypeName',
		'underlyingTypeKind',
		'definesFunction',
		'argumentIndex',
		'recordKind'
	],
	#pools : [
		'CXTypeKind'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGParameter class >> kind [

	^ CXCursor_ParmDecl
]

{ #category : 'visiting' }
IGParameter >> accept: aVisitor [

	aVisitor visitParameter: self
]

{ #category : 'accessing' }
IGParameter >> argumentIndex [

	^ argumentIndex
]

{ #category : 'private' }
IGParameter >> argumentIndexOf: aCursor [
	| cxParent |
	
	cxParent := aCursor parent.
	0 to: (cxParent numArguments - 1) do: [ :index |
		| cxArg |
		cxArg := cxParent argumentAt: index.
		(aCursor equalTo: cxArg)
			ifTrue: [ ^ index + 1 ] ].

	^ 0
]

{ #category : 'converting' }
IGParameter >> asParameterString [

	^ String streamContents: [ :stream |
		stream << self typeName << ' ' << self name ]
]

{ #category : 'accessing' }
IGParameter >> cTemplate [
	
	^ IGCParameterTemplate forParameter: self
]

{ #category : 'testing' }
IGParameter >> definesFunction [

	^ definesFunction
]

{ #category : 'initialization' }
IGParameter >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor type.
	typeName := type spelling.
	typeKind := type kind.
	argumentIndex := self argumentIndexOf: aCursor.
	
	name ifEmpty: [ 
		name := 'arg{1}' format: { argumentIndex } ].
	
	typeKind = CXType_Elaborated ifTrue: [ 
		| underlyingType |
		underlyingType :=  type namedType.
		underlyingTypeName := underlyingType spelling.
		underlyingTypeKind := underlyingType kind.
		(underlyingTypeName indexOf: $<) > 0 
			ifTrue: [ self checkForTemplateSpecialization: underlyingType ].
		underlyingTypeKind = CXType_Record 
			ifTrue: [ recordKind := underlyingType typeDeclaration kind ] ].
		
	definesFunction := ({ CXType_Pointer. CXType_LValueReference } includes: typeKind)
		and: [ { CXType_FunctionProto. CXType_FunctionNoProto } includes: type pointeeType kind ].		
				
	self isTemplateSpecialization 
		ifTrue: [ typeName := typeName copyUpTo: $< ]
]

{ #category : 'testing' }
IGParameter >> hasTypeReference [

	^ self typeReference notNil
]

{ #category : 'testing' }
IGParameter >> isElaborated [

	^ self typeKind = CXType_Elaborated
]

{ #category : 'testing' }
IGParameter >> isLValueReference [

	^ self typeKind = CXType_LValueReference
]

{ #category : 'testing' }
IGParameter >> isParameter [

	^ true
]

{ #category : 'testing' }
IGParameter >> isReference [

	^ (self parseType: self typeName) isReference
]

{ #category : 'testing' }
IGParameter >> matchesCursor: aCursor [

	^ self kind = aCursor kind 
		and: [ 
			(self name = aCursor displayName) 
				or: [ self argumentIndex = (self argumentIndexOf: aCursor) ] ]
]

{ #category : 'private' }
IGParameter >> parseType: aString [

	^ IGFunctionParser parse: aString
]

{ #category : 'accessing' }
IGParameter >> recordKind [

	^ recordKind
]

{ #category : 'accessing' }
IGParameter >> resolveType [
	
	"if elements is nil means is the first time I am here, hence I need to merge this 
	 with a posible parameter element received later when traversing the AST."	
	elements ifNil: [  
		elements := self parent elements 
			detect: [ :each | each = self ]
			ifFound: [ :aParam | aParam elements ]
			ifNone: [ #() ] ].

	^ IGParameterType fromParameter: self
]

{ #category : 'accessing' }
IGParameter >> typeKind [

	^ typeKind
]

{ #category : 'accessing' }
IGParameter >> typeKind: aNumber [
	"the kind as in CXType>>#type"

	typeKind := aNumber
]

{ #category : 'accessing' }
IGParameter >> typeName [

	^ typeName
]

{ #category : 'accessing' }
IGParameter >> underlyingTypeKind [

	^ underlyingTypeKind
]

{ #category : 'accessing' }
IGParameter >> underlyingTypeName [

	^ underlyingTypeName
]
