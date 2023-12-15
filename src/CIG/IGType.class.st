Class {
	#name : 'IGType',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'name',
		'typeReference',
		'parsedType'
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

{ #category : 'testing' }
IGType >> definesFunction [
	
	^ false
]

{ #category : 'accessing' }
IGType >> element [
	"if there is a typeRefernce, tries to answer it"
	
	self typeReferenceForParsedType ifNil: [ ^ nil ].
	^ self root elementAtPath: self typeReference namePath
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
IGType >> isPointer [

	^ self parseType arity > 0
]

{ #category : 'testing' }
IGType >> isReference [
	"answer is this type is a reference. It will came with a & at the end.
	 e.g Module &m"
	
	^ self parseType isReference
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
