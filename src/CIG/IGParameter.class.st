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
IGParameter >> disambiguateIntTypeName: aCursor [
	
	self flag: #TODO. "This can have other cases?"
	(typeName beginsWith: 'int') ifTrue: [ self disambiguatePossibleIntSizeT: aCursor ]		
]

{ #category : 'initialization' }
IGParameter >> disambiguatePossibleIntSizeT: aCursor [
	| source |
	
	source := aCursor source.
	(source beginsWith: 'size_t') ifFalse: [ ^ self ].
	
	typeName :=  typeName copyReplaceAll: 'int' with: 'size_t'
]

{ #category : 'initialization' }
IGParameter >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor type.
	typeName := type spelling.
	typeKind := type kind.
	argumentIndex := self argumentIndexOf: aCursor.

	"I need to disambiguate a kind int that is in fact declared as a size_t"
	self disambiguateIntTypeName: aCursor.
	
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
IGParameter >> isClassTemplateOf: aClassTemplate [

	^ self typeName includesSubstring: aClassTemplate name

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
IGParameter >> isTemplateOf: aClassTemplate [
	| paramTypeName |

	paramTypeName := self resolveType parseType name.
	self flag: #TODO. "Demeters law!"
	^ aClassTemplate templateTypeParameters 
		anySatisfy: [ :each | each name = paramTypeName ]
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

{ #category : 'private' }
IGParameter >> specializeClassTemplate: aClassTemplate type: aString [ 

	(self isTemplateOf: aClassTemplate) ifTrue: [ 
		typeName := IGType 
			replaceTypeTemplate: aClassTemplate 
			type: aString 
			in: typeName ].
	
	(self isClassTemplateOf: aClassTemplate) ifTrue: [ 
		typeName := IGType 
			replaceTypeClassTemplate: aClassTemplate 
			type: aString 
			in: typeName ]
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
