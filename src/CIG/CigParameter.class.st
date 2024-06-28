Class {
	#name : 'CigParameter',
	#superclass : 'CigElement',
	#traits : 'CigTTemplateSpecialization',
	#classTraits : 'CigTTemplateSpecialization classTrait',
	#instVars : [
		'typeName',
		'typeKind',
		'definesFunction',
		'argumentIndex',
		'underlyingTypeName',
		'underlyingTypeKind',
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

	cxParent := aCursor lexicalParent.
	0 to: cxParent numArguments - 1 do: [ :index |
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
CigParameter >> canBeExported [

	"I can't export parameters with && (moving references)"
	^ (self typeName endsWith: '&&') not
]

{ #category : 'testing' }
CigParameter >> definesFunction [

	^ definesFunction
]

{ #category : 'initialization' }
CigParameter >> disambiguateIntTypeName: aCursor [
	
	(typeName beginsWith: 'int') ifFalse: [ ^ self].	
	
	typeName := CigTypeDisambiguator uniqueInstance 
		disambiguateIntIn: typeName 
		with: aCursor source
]

{ #category : 'initialization' }
CigParameter >> disambiguatePossibleIntSizeT: source [
	
	(source beginsWith: 'size_t') 
		ifFalse: [ ^ false ].
	
	typeName :=  typeName copyReplaceAll: 'int' with: 'size_t'.
	^ true
]

{ #category : 'initialization' }
CigParameter >> extractElaborated: aType [

	underlyingTypeName := aType spelling.
	underlyingTypeKind := aType kind.
	(underlyingTypeName indexOf: $<) > 0 
		ifTrue: [ self checkForTemplateSpecialization: aType name: underlyingTypeName ].
	
	underlyingTypeKind = CXType_Record 
		ifTrue: [ recordKind := aType typeDeclaration kind ]
]

{ #category : 'initialization' }
CigParameter >> extractElaboratedFromSpecializationTypes [

	specializationTypes isEmptyOrNil ifTrue: [ ^ self ].
	
	underlyingTypeName := typeName.
	underlyingTypeKind := CXType_Unexposed
]

{ #category : 'initialization' }
CigParameter >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor type.
	typeName := type spelling.
	typeKind := type kind.
	argumentIndex := self argumentIndexOf: aCursor.

	self disambiguateIntTypeName: aCursor.
	self checkForTemplateSpecialization: typeName.
	
	name ifEmpty: [ 
		name := 'arg{1}' format: { argumentIndex } ].
		
	typeKind = CXType_Elaborated 
		ifTrue: [ self extractElaborated: type namedType ]
		ifFalse: [ self extractElaboratedFromSpecializationTypes ].
		
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

{ #category : 'testing' }
CigParameter >> nameMatchesLastOf: aString [
	
	(aString size < self name size) ifTrue: [ ^ false ].	
	^ (aString last: self name size) sameAs: self name
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

	^ CigType fromParameter: self
]

{ #category : 'private' }
CigParameter >> specializeClassTemplate: aClassTemplate types: aString [ 

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

{ #category : 'private' }
CigParameter >> typeNameForType [

	^ underlyingTypeName ifNil: [ typeName ]
]

{ #category : 'accessing' }
CigParameter >> underlyingTypeKind [

	^ underlyingTypeKind
]

{ #category : 'accessing' }
CigParameter >> underlyingTypeName [

	^ underlyingTypeName
]
