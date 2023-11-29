Class {
	#name : 'IGType',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'name',
		'typeReference'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
IGType >> cDeclaration [
	| parsed typeName |

	parsed := self parseType.
	typeName := parsed name.
	
	(typeName includes: $:) ifTrue: [ 
		IGTranslationMap uniqueInstance 
			cDeclarationOf: typeName 
			ifFound: [ :aDecl | ^ aDecl ] ]. 
	
	^ String streamContents: [ :stream |
		self typeReference
			ifNotNil: [ stream << (self cDeclarationFromReference ifNil: [ typeName ]) ]
			ifNil: [ stream << typeName ].
				
		parsed isReference ifTrue: [ stream << '*' ].
		1 to: parsed arity do: [ :each |
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

	(typeName includes: $:) ifTrue: [ 
		IGTranslationMap uniqueInstance 
			cppDeclarationOf: typeName 
			ifFound: [ :aDecl | ^ aDecl ] ]. 
	
	
	^ String streamContents: [ :stream |
		self typeReference 
			ifNotNil: [ stream << ((self cppDeclarationFromReference) ifNil: [ typeName ]) ]
			ifNil: [ stream << typeName ].
		parsed isReference ifTrue: [ stream << '*' ].
		1 to: parsed arity do: [ :each |
			stream << '*' ] ]
]

{ #category : 'private' }
IGType >> cppDeclarationFromReference [

	^ (self parent root elementAtPath: (self typeReference typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cppDeclaration ]
]

{ #category : 'testing' }
IGType >> hasTypeReference [
	"includes a reference explanation"

	^ self typeReference notNil
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
	
	^ IGFunctionParser parse: self name
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
