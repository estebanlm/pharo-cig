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
		'definesFunction'
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

{ #category : 'initialization' }
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
IGParameter >> asArgumentString [

	^ String streamContents: [ :stream |
		self isElaborated ifTrue: [
			"I will cast all elaborated types (it can't be bad, the 
			 compiler will eat it if not needed)"
			stream << '(' << self castString << ')' ].
		stream << self name ]
]

{ #category : 'converting' }
IGParameter >> asParameterString [

	^ String streamContents: [ :stream |
		stream << self typeName << ' ' << self name ]
]

{ #category : 'private' }
IGParameter >> castString [
	| element |
	
	element := self root findDeepElementMatching: [ :each | each name = self typeName ].
	element ifNotNil: [
		"if elaborated element is an enum. we will need a cast"
		element isEnum ifTrue: [ ^ element fullName ].
		self flag: #TODO. "I need to complete with other elaborated types" ].

	"this is actually not a cast, but well... :P"
	^ self typeName
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
	
	name ifEmpty: [ 
		name := 'arg{1}' format: { self argumentIndexOf: aCursor } ].
	
	typeKind = CXType_Elaborated ifTrue: [ 
		| underlyingType |
		underlyingType :=  type namedType.
		underlyingTypeName := underlyingType spelling.
		underlyingTypeKind := underlyingType kind.
		(underlyingTypeName indexOf: $<) > 0 
			ifTrue: [ self checkForTemplateSpecialization: underlyingType ] ].
		
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
IGParameter >> isReference [

	^ (self parseType: self typeName) isReference
]

{ #category : 'private' }
IGParameter >> parseType: aString [

	^ IGFunctionParser parse: aString
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

	^ IGParameterType new
		parent: self;
		name: self typeName;
		definesFunction: self definesFunction;
		typeReference: (self typeReference ifNil: [ 
			self isTemplateSpecialization 
				ifTrue: [ 
					(IGTypeReference newName: 'class ', self typeName)
						parent: self;
						yourself ]
				ifFalse: [ nil ] ]);
		yourself
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
