Class {
	#name : 'CigType',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'name',
		'typeReference',
		'parsedType',
		'element',
		'definesFunction'
	],
	#classVars : [
		'TypeMap'
	],
	#pools : [
		'CigCPPTypedef'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'private' }
CigType class >> createTypeMap [

	^ Dictionary newFromPairs: {
	'unsigned'. #uint.
	'unsigned int'. #uint.
	'unsigned long'. #ulong.
	'unsigned short'. #ushort.
	'unsigned char'. #uchar.
	}
]

{ #category : 'utilities' }
CigType class >> replaceTypeClassTemplate: aClassTemplate type: typeString in: aString [ 

	^ self 
		replaceTypeClassTemplate: aClassTemplate 
		types: { typeString } 
		in: aString
]

{ #category : 'utilities' }
CigType class >> replaceTypeClassTemplate: aClassTemplate types: aCollection in: aString [ 
	| type classType classTemplateType |
	
	type := CigFunctionParser parse: aString.
	classTemplateType := String streamContents: [ :stream | 
		stream << aClassTemplate basename << '<' << ((aClassTemplate templateTypeParameters collect: #name) asCommaString) << '>' ].
	
	(aString includesSubstring: classTemplateType)
		ifFalse: [ self error: 'Class templates do not correspond to type to match.' ]. 
	
	classType := String streamContents: [ :stream | 
		stream << aClassTemplate basename << '<' << aCollection asCommaString << '>' ].
		
	^ String streamContents: [ :stream | 
		(aString includesSubstring: 'const ')
			ifTrue: [ stream << 'const ' ].
		stream << classType.
		(type arity - (type isReference ifTrue: [ 1 ] ifFalse: [ 0 ])) timesRepeat: [ 
			stream << '*' ].
		type isReference ifTrue: [ 
			stream << '&' ] ]
]

{ #category : 'utilities' }
CigType class >> replaceTypeTemplate: aClassTemplate type: typeString in: aString [

	^ self 
		replaceTypeTemplate: aClassTemplate 
		types: { typeString } 
		in: aString

]

{ #category : 'utilities' }
CigType class >> replaceTypeTemplate: aClassTemplate types: aCollection in: aString [
	| type params index |

	type := CigFunctionParser parse: aString.

	params := aClassTemplate templateTypeParameters.
	(params anySatisfy: [ :each | each name = type name ])
		ifFalse: [ self error: 'Class templates do not correspond to type to match.' ]. 
		
	^ String streamContents: [ :stream | 
		(aString includesSubstring: 'const ') 
			ifTrue: [ stream << 'const ' ].
		index := params indexOf: (params detect: [ :each | each name = type name ]).
		stream << (aCollection at: index).
		(type arity - (type isReference ifTrue: [ 1 ] ifFalse: [ 0 ])) timesRepeat: [ 
			stream << '*' ].
		type isReference ifTrue: [ 
			stream << '&' ] ]
]

{ #category : 'utilities' }
CigType class >> resolveFFIType: aString [

	^ [ FFICallout new 
			requestor: self; 
			resolveType: aString.
		 "it can be solved, just answer it"
		 aString ]
	on: Error 
	do: [ :e | | type |
		type := aString copyWithoutAll: #($* $&).
		"it can't be solved, trying a conversion table"
		self typeMap 
			at: type
			ifPresent: [ :aType | aString copyReplaceAll: type with: aType ]
			ifAbsent: [ self error: 'C type can''t be mapped to a n FFIType' ] ]
]

{ #category : 'private' }
CigType class >> typeMap [
		
	^ TypeMap ifNil: [ TypeMap := self createTypeMap ]
]

{ #category : 'testing' }
CigType >> definesFunction [
	
	^ false
]

{ #category : 'accessing' }
CigType >> element [
	"if there is a typeReference, tries to answer it"

	^ element ifNil: [ 
		element := self typeReferenceForParsedType
			ifNotNil: [ :aTypeReference |
				"it can be an element from the tree (class, etc.)"
				aTypeReference matchingElementInUnit ]
			ifNil: [ 
				"it can be a typedef or an existing node without a type reference"
				self parent scopeLookup: self parseType nameWithSpecialization ] ]
]

{ #category : 'testing' }
CigType >> hasElement [
	
	^ self element notNil
]

{ #category : 'testing' }
CigType >> hasTypeReference [
	"includes a reference explanation"

	^ self typeReferenceForParsedType notNil
]

{ #category : 'testing' }
CigType >> isAnyDeclaration [
	
	self hasElement ifFalse: [ ^ false ].
	^ self element isTypedef 
		or: [ self element isUsingDeclaration ]
]

{ #category : 'testing' }
CigType >> isClass [

	^ self hasElement and: [ self element isClass ]
]

{ #category : 'testing' }
CigType >> isClassTemplate [

	^ self element notNil and: [ self element isClassTemplate ]
]

{ #category : 'testing' }
CigType >> isConst [
	
	^ self name beginsWith: 'const '
]

{ #category : 'testing' }
CigType >> isEnum [

	^ self hasElement and: [ self element isEnum ]
]

{ #category : 'testing' }
CigType >> isFunction [

	^ self definesFunction
]

{ #category : 'testing' }
CigType >> isPointer [

	^ self parseType arity > 0
]

{ #category : 'testing' }
CigType >> isReference [
	"answer is this type is a reference. It will came with a & at the end.
	 e.g Module &m"
	
	^ self parseType isReference
]

{ #category : 'testing' }
CigType >> isSpecial [
	
	^ self hasElement and: [ self element isSpecial ]
]

{ #category : 'testing' }
CigType >> isStructure [

	^ self element notNil and: [ self element isStructure ]
]

{ #category : 'testing' }
CigType >> isTemplateSpecialization [
	
	^ self parent isParameter and: [ self parent isTemplateSpecialization ]

]

{ #category : 'testing' }
CigType >> isTypedef [
	
	^ self element notNil
		and: [ self element isTypedef ]
]

{ #category : 'private' }
CigType >> matchTypeName: aName with: otherName [

	^ (aName substrings: '::') last = otherName
]

{ #category : 'accessing' }
CigType >> name [

	^ name
]

{ #category : 'accessing' }
CigType >> name: aName [

	name := aName
]

{ #category : 'accessing' }
CigType >> parent [

	^ parent
]

{ #category : 'accessing' }
CigType >> parent: aNode [

	parent := aNode
]

{ #category : 'private' }
CigType >> parseType [
	
	^ parsedType ifNil: [ 
		parsedType := CigFunctionParser parse: self name ]
]

{ #category : 'accessing' }
CigType >> pointerArity [
	
	^ self parseType arity
]

{ #category : 'testing' }
CigType >> requiresCast [
	"There are some type cases that require an explicit cast. 
	 For now the only case I know is in case we have a typedef to a function, but that mey be other in the future"
	
	^ self hasElement 
		and: [ self element isTypedef
		and: [ self element definesFunction ] ]
]

{ #category : 'accessing' }
CigType >> root [
	
	^ self parent root
]

{ #category : 'accessing' }
CigType >> typeReference [

	^ typeReference
]

{ #category : 'accessing' }
CigType >> typeReference: aTypeReference [

	typeReference := aTypeReference

]

{ #category : 'private' }
CigType >> typeReferenceForParsedType [
	| typeRef |
	
	typeRef := self typeReference.
	typeRef ifNil: [ ^ nil ].
	
	^ (self matchTypeName: typeRef name with: self parseType nameWithoutNamespace)
		ifTrue: [ typeRef ]
		ifFalse: [ nil ]
]
