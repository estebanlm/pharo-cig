Class {
	#name : 'IGType',
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

{ #category : 'accessing' }
IGType >> cDeclaration [
	| parsed typeName startArity |

	startArity := 0.
	parsed := self parseType.
	typeName := parsed name.
	
	self ifTranslated: [ :translation | ^ translation cDeclarationOf: self ].
	
	^ String streamContents: [ :stream |
		self typeReferenceForParsedType
			ifNotNil: [ 
				| refDeclaration |
				refDeclaration := self cDeclarationFromReference ifNil: [ typeName ].
				stream << refDeclaration.
				"type is already a pointer, in the case of classes"
				refDeclaration last = $*
					ifTrue: [ startArity := 1 ] ]
			ifNil: [ 
				"there may still be a typedef type (format namespace::type), we just 
				 replace that"
				| path |
				path := typeName substrings: '::'.
				stream << ((self root elementAtPath: path) 
					ifNotNil: [ :anElement | anElement cDeclaration ]
					ifNil: [ typeName ]) ].
				
		(1 + startArity) to: parsed arity do: [ :each |
			stream << '*' ] ]
]

{ #category : 'accessing' }
IGType >> cDeclarationForFFI [
	
	self flag: #TODO. "This will not work all the time, since we need to declare 
	some C types differently (e.g. unsigned = uint, unsigned long = ulong, etc.)"
	^ self cDeclaration
]

{ #category : 'private' }
IGType >> cDeclarationFromReference [
	| typeName |
	
	typeName := self typeReference typeName.
	^ (self parent root elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
]

{ #category : 'private' }
IGType >> cDeclarationFromReferenceWithSpecialization: aCollection [
	| typeName |
	
	typeName := self typeReference typeName.
	^ (self parent root elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclarationWithSpecialization: aCollection ]
]

{ #category : 'accessing' }
IGType >> cppDeclaration [
	| parsed typeName |

	parsed := self parseType.
	typeName := parsed name.

	self ifTranslated: [ :translation | ^ translation cppDeclarationOf: self ].
	
	^ String streamContents: [ :stream |
		self typeReference 
			ifNotNil: [ stream << ((self cppDeclarationFromReference) ifNil: [ typeName ]) ]
			ifNil: [ stream << typeName ].
		1 to: parsed arity do: [ :each |
			stream << '*' ] ]
]

{ #category : 'private' }
IGType >> cppDeclarationFromReference [

	^ (self parent root elementAtPath: (self typeReference typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cppDeclaration ]
]

{ #category : 'private' }
IGType >> cppDeclarationFromReferenceWithSpecialization: aCollection [

	^ (self parent root elementAtPath: (self typeReference typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cppDeclarationWithSpecialization: aCollection ]
]

{ #category : 'testing' }
IGType >> definesFunction [
	
	^ false
]

{ #category : 'accessing' }
IGType >> element [
	"if there is a typeRefernce, tries to answer it"
	
	^ element ifNil: [ 
		element := self typeReferenceForParsedType 
			ifNotNil: [ 
				"it can be an element from the tree (class, etc.)"
				self root elementAtPath: self typeReference namePath ]
			ifNil: [ 
				"it can be a typedef"
				self root elementAtPath: (self parseType name substrings: '::') ] ]
]

{ #category : 'testing' }
IGType >> hasElement [
	
	^ self element notNil
]

{ #category : 'testing' }
IGType >> hasTypeReference [
	"includes a reference explanation"

	^ self typeReferenceForParsedType notNil
]

{ #category : 'accessing' }
IGType >> ifTranslated: aBlock [

	^ self ifTranslated: aBlock ifNot: [ ]
]

{ #category : 'accessing' }
IGType >> ifTranslated: aBlock ifNot: notBlock [
	| typeName |

	^ IGTranslationMap uniqueInstance 
		atType: self
		ifPresent: [ :aTranslation | aBlock value: aTranslation ]
		ifAbsent: [ notBlock value ]
]

{ #category : 'testing' }
IGType >> isAnyDeclaration [
	
	self hasElement ifFalse: [ ^ false ].
	^ self element isTypedef 
		or: [ self element isUsingDeclaration ]
]

{ #category : 'testing' }
IGType >> isClass [

	^ self hasElement and: [ self element isClass ]
]

{ #category : 'testing' }
IGType >> isClassTemplate [

	^ self element notNil and: [ self element isClassTemplate ]
]

{ #category : 'testing' }
IGType >> isConst [
	
	^ self name beginsWith: 'const '
]

{ #category : 'testing' }
IGType >> isEnum [

	^ self hasElement and: [ self element isEnum ]
]

{ #category : 'testing' }
IGType >> isFunction [

	^ self definesFunction
]

{ #category : 'testing' }
IGType >> isPointer [

	^ self parseType arity > 0
]

{ #category : 'testing' }
IGType >> isReference [
	"answer is this type is a reference. It will came with a & at the end.
	 e.g Module &m"
	
	^ self parseType isReference
]

{ #category : 'testing' }
IGType >> isStructure [

	^ self element notNil and: [ self element isStructure ]
]

{ #category : 'testing' }
IGType >> isTemplateSpecialization [
	
	^ self parent isParameter and: [ self parent isTemplateSpecialization ]

]

{ #category : 'testing' }
IGType >> isTypedef [
	
	^ self element notNil
		and: [ self element isTypedef ]
]

{ #category : 'accessing' }
IGType >> name [

	^ name
]

{ #category : 'accessing' }
IGType >> name: aName [

	name := aName
]

{ #category : 'accessing' }
IGType >> parent [

	^ parent
]

{ #category : 'accessing' }
IGType >> parent: aNode [

	parent := aNode
]

{ #category : 'private' }
IGType >> parseType [
	
	^ parsedType ifNil: [ 
		parsedType := IGFunctionParser parse: self name ]
]

{ #category : 'private' }
IGType >> phDeclarationFromReferenceWith: aPrefix [
	
	^ aPrefix, self typeReference typeBasename capitalized
]

{ #category : 'accessing' }
IGType >> phDeclarationWith: aPrefix [
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
IGType >> pointerArity [
	
	^ self parseType arity
]

{ #category : 'testing' }
IGType >> requiresCast [
	"There are some type cases that require an explicit cast. 
	 For now the only case I know is in case we have a typedef to a function, but that mey be other in the future"
	
	^ self hasElement 
		and: [ self element isTypedef
		and: [ self element definesFunction ] ]
]

{ #category : 'private' }
IGType >> resolveFFIType: aString ifFound: foundBlock ifAbsent: absentBlock [

	^ [ 
		foundBlock value: (FFIExternalType resolveType: aString) ]
	on: Error 
	do: [ :e | absentBlock value ]
]

{ #category : 'accessing' }
IGType >> root [
	
	^ self parent root
]

{ #category : 'private' }
IGType >> tryKnownType: aString ifFound: aBlock [
	"a place to check for known types and go back and forth"

	self flag: #TODO. "Put this in a config file"	
	aString = 'std::string' ifTrue: [ ^ aBlock value: 'const char*' ]
]

{ #category : 'accessing' }
IGType >> typeReference [

	^ typeReference
]

{ #category : 'accessing' }
IGType >> typeReference: aTypeReference [

	typeReference := aTypeReference

]

{ #category : 'private' }
IGType >> typeReferenceForParsedType [
	| typeRef |
	
	typeRef := self typeReference.
	typeRef ifNil: [ ^ nil ].
	
	^ (typeRef name endsWith: self parseType name)
		ifTrue: [ typeRef ]
		ifFalse: [ nil ]
]
