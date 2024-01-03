Class {
	#name : 'CigType',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'name',
		'typeReference',
		'parsedType',
		'element'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'utils' }
CigType class >> replaceTypeClassTemplate: aClassTemplate type: typeString in: aString [ 
	| type classType classTemplateType |
	
	aClassTemplate templateTypeParameters size > 1 ifTrue: [ 
		self error: 'I can''t handle more than one parameter class templates.' ].
	
	type := CigFunctionParser parse: aString.
	classTemplateType := String streamContents: [ :stream | 
			stream << aClassTemplate basename << '<' << aClassTemplate templateTypeParameters first name << '>' ].
	
	(aString includesSubstring: classTemplateType)
		ifFalse: [ self error: 'Class templates do not correspond to type to match.' ]. 
	
	classType := String streamContents: [ :stream | 
			stream << aClassTemplate basename << '<' << typeString << '>' ].
		
	^ String streamContents: [ :stream | 
		(aString includesSubstring: 'const ')
			ifTrue: [ stream << 'const ' ].
		stream << classType.
		(type arity - (type isReference ifTrue: [ 1 ] ifFalse: [ 0 ])) timesRepeat: [ 
			stream << '*' ].
		type isReference ifTrue: [ 
			stream << '&' ] ]
]

{ #category : 'utils' }
CigType class >> replaceTypeTemplate: aClassTemplate type: typeString in: aString [
	| type |


	type := CigFunctionParser parse: aString.

	(aClassTemplate templateTypeParameters anySatisfy: [ :each | each name = type name ])
		ifFalse: [ self error: 'Class templates do not correspond to type to match.' ]. 
		
	^ String streamContents: [ :stream | 
		(aString includesSubstring: 'const ') 
			ifTrue: [ stream << 'const ' ].
		stream << typeString.
		(type arity - (type isReference ifTrue: [ 1 ] ifFalse: [ 0 ])) timesRepeat: [ 
			stream << '*' ].
		type isReference ifTrue: [ 
			stream << '&' ] ]
]

{ #category : 'accessing' }
CigType >> cDeclarationForFFI [
	
	self flag: #TODO. "This will not work all the time, since we need to declare 
	some C types differently (e.g. unsigned = uint, unsigned long = ulong, etc.)"
	^ self cDeclaration
]

{ #category : 'private' }
CigType >> cDeclarationFromReference [
	| typeName |
	
	typeName := self typeReference typeName.
	^ (self parent root elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
]

{ #category : 'private' }
CigType >> cDeclarationFromReferenceWithSpecialization: aCollection [
	| typeName |
	
	typeName := self typeReference typeName.
	^ (self parent root elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclarationWithSpecialization: aCollection ]
]

{ #category : 'private' }
CigType >> cppDeclarationFromReference [

	^ (self parent root elementAtPath: (self typeReference typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cppDeclaration ]
]

{ #category : 'private' }
CigType >> cppDeclarationFromReferenceWithSpecialization: aCollection [

	^ (self parent root elementAtPath: (self typeReference typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cppDeclarationWithSpecialization: aCollection ]
]

{ #category : 'testing' }
CigType >> definesFunction [
	
	^ false
]

{ #category : 'accessing' }
CigType >> element [
	"if there is a typeRefernce, tries to answer it"
	
	^ element ifNil: [ 
		element := self typeReferenceForParsedType 
			ifNotNil: [ 
				"it can be an element from the tree (class, etc.)"
				self root elementAtPath: self typeReference namePath ]
			ifNil: [ 
				"it can be a typedef"
				self root elementAtPath: (self parseType nameWithSpecialization substrings: '::') ] ]
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

{ #category : 'private' }
CigType >> phDeclarationFromReferenceWith: aPrefix [
	
	^ aPrefix, self typeReference typeBasename capitalized
]

{ #category : 'accessing' }
CigType >> phDeclarationWith: aPrefix [
	| parsed typeName |

	parsed := self parseType.
	typeName := parsed name.
	
	^ String streamContents: [ :stream |
		self typeReference 
			ifNotNil: [ 
				stream << ((self phDeclarationFromReferenceWith: aPrefix) ifNil: [ aPrefix, typeName ]) ]
			ifNil: [
				self 
					resolveFFIType: typeName
					ifFound: [ :aType | stream << '#' << aType typeName ]
					ifAbsent: [ stream << typeName ] ].
				
		parsed isReference ifTrue: [ stream << '*' ].
		1 to: parsed arity do: [ :each |
			stream << '*' ] ]
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

{ #category : 'private' }
CigType >> resolveFFIType: aString ifFound: foundBlock ifAbsent: absentBlock [

	^ [ 
		foundBlock value: (FFIExternalType resolveType: aString) ]
	on: Error 
	do: [ :e | absentBlock value ]
]

{ #category : 'accessing' }
CigType >> root [
	
	^ self parent root
]

{ #category : 'private' }
CigType >> tryKnownType: aString ifFound: aBlock [
	"a place to check for known types and go back and forth"

	self flag: #TODO. "Put this in a config file"	
	aString = 'std::string' ifTrue: [ ^ aBlock value: 'const char*' ]
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
	
	^ (typeRef name endsWith: self parseType name)
		ifTrue: [ typeRef ]
		ifFalse: [ nil ]
]
