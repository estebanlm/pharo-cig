"
A class that contains a resolved type : in includes all information used to correctly generate C and Pharo bindings.
It can parse the type from a string to generate a `CigTypeDeclaration` (which splits types into its components).
It also collaborates with its owner and translation unit to retrieve an element reference when needed.
"
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

{ #category : 'utilities' }
CigType class >> canBeExported: aString [
	"Some types cannot be exported. 
		- I can't export parameters with && (moving references)"

	^ (aString endsWith: '&&') not
]

{ #category : 'private' }
CigType class >> createTypeMap [

	^ Dictionary newFromPairs: {
	'unsigned'. 			#uint.
	'unsigned int'. 	#uint.
	'unsigned long'. 	#ulong.
	'unsigned short'. 	#ushort.
	'unsigned char'. 	#uchar.
	}
]

{ #category : 'utilities' }
CigType class >> extractAnonymousLocation: aString [ 
	
	 ^ (aString substrings: ' ()') last
]

{ #category : 'instance creation' }
CigType class >> fromParameter: aParameter [

	^ self new fromParameter: aParameter
]

{ #category : 'utilities' }
CigType class >> isAnonymous: aString [

	^ #('(anonymous' '(unnamed') 
		anySatisfy: [ :each | aString includesSubstring: each ]
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

		^ [ 
			FFICallout new 
				requestor: self; 
				resolveType: (CigFunctionParser parse: aString) nameWithArity.
			"it can be solved, just answer it"
			self resolveMappedType: aString ]
		on: Error 
		do: [ :e |
			"it cannot be solved, still try to fix if mapped type" 
			self 
				resolveMappedType: aString
				ifAbsent: [ self error: aString, ' can''t be mapped to a n FFIType' ] ]
]

{ #category : 'utilities' }
CigType class >> resolveMappedType: aString [
		
	^ self 
		resolveMappedType: aString 
		ifAbsent: [ aString ]
]

{ #category : 'utilities' }
CigType class >> resolveMappedType: aString ifAbsent: aBlock [
	| type |
	
	type := type := aString copyWithoutAll: #($* $&).
	^ self typeMap 
		at: type
		ifPresent: [ :aType | aString copyReplaceAll: type with: aType ]
		ifAbsent: aBlock
]

{ #category : 'utilities' }
CigType class >> sanitizeTypeName: aString [
	| substrings |
	
	substrings := aString substrings.
	substrings size > 1 ifTrue: [
		(#('const' 'struct' 'union' 'enum') includes: substrings first)
			ifTrue: [ ^ ' ' join: substrings allButFirst ] ].
	
	^ aString
]

{ #category : 'utilities' }
CigType class >> toTypePath: aString [
	|  remaining |
	
	remaining := aString.
	^ Array streamContents: [ :stream |	
		[ remaining includesSubstring: '::' ] whileTrue: [ 
			| pos |
			pos := remaining findString: '::'.
			stream nextPut: (remaining first: pos - 1).
			remaining := remaining allButFirst: pos + 1 ].
		stream nextPut: remaining ]
]

{ #category : 'private' }
CigType class >> typeMap [
		
	^ TypeMap ifNil: [ TypeMap := self createTypeMap ]
]

{ #category : 'testing' }
CigType >> definesFunction [
	
	^ definesFunction ifNil: [ false ]
]

{ #category : 'accessing' }
CigType >> definesFunction: aBoolean [

	definesFunction := aBoolean
]

{ #category : 'private' }
CigType >> disambiguatePossibleReference: aNode [

	aNode ifNil: [ ^ nil ].
	
	"struct and union can be contained in another struct or union but just be a reference 
	 (since libclang will send a struct definition anyway).
	 take this example: 
	 struct B { ...something here... }
	 struct A {
	 	struct B *b;
	 }
	 libclang will visit all members of the structure inside struct A, and it will then 
	 add a child to our struct node. This will be later NOT traversed (since is just a declaration) 
	 and then it will be empty.
	 So... this may happen because in new versions of C++ you can declare structs and unions without 
	 name and there is a way to access their members directly (but if empty it does not has any sense)."
	(aNode isStructure 
		and: [ aNode hasElements not
		and: [ aNode parent ~= self root
		and: [ aNode parent isStructure ] ] ])
		ifTrue: [ 
			(self root elementAtPath: { aNode name })
				ifNotNil: [ :realNode | ^ realNode ] ].
			
	^ aNode
]

{ #category : 'accessing' }
CigType >> element [
	"if there is a typeReference, tries to answer it"

	^ element ifNil: [ 
		element := self disambiguatePossibleReference: (self typeReferenceForParsedType
			ifNotNil: [ :aTypeReference |
				"it can be an element from the tree (class, etc.)"
				aTypeReference matchingElementInUnit ]
			ifNil: [ 
				"it can be a typedef or an existing node without a type reference"
				 self parent scopeLookup: self parseType nameWithSpecialization ]) ]
]

{ #category : 'initialization' }
CigType >> fromParameter: aParameter [

	self
		parent: aParameter;
		name: aParameter typeNameForType;
		definesFunction: aParameter definesFunction;
		typeReference: (self typeReferenceFrom: aParameter)
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

	self isReferenceAnonymous ifTrue: [ ^ false ].
	^ self parseType arity > 0
]

{ #category : 'testing' }
CigType >> isReference [
	"answer is this type is a reference. It will came with a & at the end.
	 e.g Module &m"
	
	"I can't parse an anonymous type, and also... it is not a reference :)"
	self isReferenceAnonymous ifTrue: [ ^ false ].
	
	^ self parseType isReference
]

{ #category : 'testing' }
CigType >> isReferenceAnonymous [ 
	
	^ self typeReference isNotNil 
		and: [ self typeReference isReferenceAnonymous ]
]

{ #category : 'testing' }
CigType >> isSpecial [
	
	^ self hasElement and: [ self element isSpecial ]
]

{ #category : 'testing' }
CigType >> isStructure [

	^ self element isNotNil and: [ self element isStructure ]
]

{ #category : 'testing' }
CigType >> isTemplateSpecialization [
	
	^ self parent isParameter and: [ self parent isTemplateSpecialization ]

]

{ #category : 'testing' }
CigType >> isType: aString [ 
	
	self isReferenceAnonymous 
		ifTrue: [ ^ false ].
	
	^ self parseType name = aString
]

{ #category : 'testing' }
CigType >> isTypedef [
	
	^ self element notNil
		and: [ self element isTypedef ]
]

{ #category : 'testing' }
CigType >> isUnion [

	^ self element notNil and: [ self element isUnion ]
]

{ #category : 'private' }
CigType >> matchAnonymousName: aString [
	| anonymousName |

	"aString comes with the format 'union (unnamed... etc)' or similar"
	anonymousName := '(', (aString substrings: '()') second, ')'.
	^ anonymousName = self typeReference typeName
]

{ #category : 'private' }
CigType >> matchTypeName: aName [
	
	self isReferenceAnonymous 
		ifTrue: [ ^ self matchAnonymousName: aName ].
	^ self matchTypeName: aName with: self parseType nameWithoutNamespace
]

{ #category : 'private' }
CigType >> matchTypeName: aName with: otherName [

	^ (CigType toTypePath: aName) last = otherName
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
	
	^ (self matchTypeName: typeRef name)
		ifTrue: [ typeRef ]
		ifFalse: [ nil ]
]

{ #category : 'private' }
CigType >> typeReferenceFrom: aParameter [

	aParameter typeReferences ifNotEmpty: [ :references | 
		"which one is good?"
		| parsedName |
		
		references size = 1 ifTrue: [ ^ references anyOne ].
		
		parsedName := (CigFunctionParser parse: aParameter typeName) name.
		references 
			detect: [ :each | each typeName endsWith: parsedName ]
			ifFound: [ :each | ^ each ] ].

	aParameter isTemplateSpecialization ifTrue: [ 
		^ (CigTypeReference newName: 'class ', aParameter typeName)
			parent: aParameter;
			yourself ].
	
	aParameter recordKind = CigClass kind ifTrue: [ 
		^ (CigTypeReference newName: 'class ', aParameter typeName)
			parent: aParameter;
			yourself ].

	aParameter recordKind = CigStructure kind ifTrue: [ 
		^ (CigTypeReference newName: 'struct ', aParameter typeName)
			parent: aParameter;
			yourself ].

	aParameter underlyingTypeKind = CigTypedef typeKind ifTrue: [ 
		^ (CigTypeReference newName: 'typedef ', aParameter underlyingTypeName)
			parent: aParameter;
			yourself ].

	^ nil
]
