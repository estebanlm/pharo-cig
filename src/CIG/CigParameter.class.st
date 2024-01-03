Class {
	#name : 'CigParameter',
	#superclass : 'CigElement',
	#traits : 'CigTTemplateSpecialization',
	#classTraits : 'CigTTemplateSpecialization classTrait',
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
CigParameter class >> kind [

	^ CXCursor_ParmDecl
]

{ #category : 'visiting' }
CigParameter >> accept: aVisitor [

	aVisitor visitParameter: self
]

{ #category : 'accessing' }
CigParameter >> argumentIndex [

	^ argumentIndex
]

{ #category : 'private' }
CigParameter >> argumentIndexOf: aCursor [
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
CigParameter >> asParameterString [

	^ String streamContents: [ :stream |
		stream << self typeName << ' ' << self name ]
]

{ #category : 'accessing' }
CigParameter >> cTemplate [
	
	^ CigCParameterTemplate forParameter: self
]

{ #category : 'testing' }
CigParameter >> definesFunction [

	^ definesFunction
]

{ #category : 'initialization' }
CigParameter >> disambiguateIntTypeName: aCursor [
	
	self flag: #TODO. "This can have other cases?"
	(typeName beginsWith: 'int') ifTrue: [ self disambiguatePossibleIntSizeT: aCursor ]		
]

{ #category : 'initialization' }
CigParameter >> disambiguatePossibleIntSizeT: aCursor [
	| source |
	
	source := aCursor source.
	(source beginsWith: 'size_t') ifFalse: [ ^ self ].
	
	typeName :=  typeName copyReplaceAll: 'int' with: 'size_t'
]

{ #category : 'initialization' }
CigParameter >> fromCursor: aCursor [
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
CigParameter >> hasTypeReference [

	^ self typeReference notNil
]

{ #category : 'testing' }
CigParameter >> isClassTemplateOf: aClassTemplate [

	^ self typeName includesSubstring: aClassTemplate name

]

{ #category : 'testing' }
CigParameter >> isDeclType [

	^ self typeName beginsWith: 'decltype'
]

{ #category : 'testing' }
CigParameter >> isElaborated [

	^ self typeKind = CXType_Elaborated
]

{ #category : 'testing' }
CigParameter >> isLValueReference [

	^ self typeKind = CXType_LValueReference
]

{ #category : 'testing' }
CigParameter >> isParameter [

	^ true
]

{ #category : 'testing' }
CigParameter >> isReference [

	^ (self parseType: self typeName) isReference
]

{ #category : 'testing' }
CigParameter >> isTemplateOf: aClassTemplate [
	| paramTypeName |

	paramTypeName := self resolveType parseType name.
	self flag: #TODO. "Demeters law!"
	^ aClassTemplate templateTypeParameters 
		anySatisfy: [ :each | each name = paramTypeName ]
]

{ #category : 'testing' }
CigParameter >> matchesCursor: aCursor [

	^ self kind = aCursor kind 
		and: [ 
			(self name = aCursor displayName) 
				or: [ self argumentIndex = (self argumentIndexOf: aCursor) ] ]
]

{ #category : 'private' }
CigParameter >> parseType: aString [

	^ CigFunctionParser parse: aString
]

{ #category : 'accessing' }
CigParameter >> recordKind [

	^ recordKind
]

{ #category : 'accessing' }
CigParameter >> resolveType [
	
	"if elements is nil means is the first time I am here, hence I need to merge this 
	 with a posible parameter element received later when traversing the AST."	
	elements ifNil: [  
		elements := self parent elements 
			detect: [ :each | each = self ]
			ifFound: [ :aParam | aParam elements ]
			ifNone: [ #() ] ].

	^ CigParameterType fromParameter: self
]

{ #category : 'private' }
CigParameter >> specializeClassTemplate: aClassTemplate type: aString [ 

	(self isTemplateOf: aClassTemplate) ifTrue: [ 
		typeName := CigType 
			replaceTypeTemplate: aClassTemplate 
			type: aString 
			in: typeName ].
	
	(self isClassTemplateOf: aClassTemplate) ifTrue: [ 
		typeName := CigType 
			replaceTypeClassTemplate: aClassTemplate 
			type: aString 
			in: typeName ]
]

{ #category : 'accessing' }
CigParameter >> typeKind [

	^ typeKind
]

{ #category : 'accessing' }
CigParameter >> typeKind: aNumber [
	"the kind as in CXType>>#type"

	typeKind := aNumber
]

{ #category : 'accessing' }
CigParameter >> typeName [

	^ typeName
]

{ #category : 'accessing' }
CigParameter >> underlyingTypeKind [

	^ underlyingTypeKind
]

{ #category : 'accessing' }
CigParameter >> underlyingTypeName [

	^ underlyingTypeName
]
