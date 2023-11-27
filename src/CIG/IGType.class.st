Class {
	#name : 'IGType',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'name',
		'reference'
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
	
	^ String streamContents: [ :stream |
		self reference 
			ifNotNil: [ stream << ((self cDeclarationFromReference) ifNil: [ typeName ]) ]
			ifNil: [ stream << typeName ].
				
		parsed isReference ifTrue: [ stream << '*' ].
		1 to: parsed arity do: [ :each |
			stream << '*' ] ]
]

{ #category : 'private' }
IGType >> cDeclarationFromReference [
	
	^ (self parent root elementAtPath: (self reference typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
]

{ #category : 'accessing' }
IGType >> cppDeclaration [
	| parsed typeName |

	parsed := self parseType.
	typeName := parsed name.
	
	^ String streamContents: [ :stream |
		self reference 
			ifNotNil: [ stream << ((self cppDeclarationFromReference) ifNil: [ typeName ]) ]
			ifNil: [ stream << typeName ].
		parsed isReference ifTrue: [ stream << '*' ].
		1 to: parsed arity do: [ :each |
			stream << '*' ] ]
]

{ #category : 'private' }
IGType >> cppDeclarationFromReference [

	^ (self parent root elementAtPath: (self reference typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cppDeclaration ]
]

{ #category : 'testing' }
IGType >> hasTypeReference [
	"includes a reference explanation"

	^ self reference notNil
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

{ #category : 'parsing' }
IGType >> parseType [
	
	^ IGFunctionParser parse: self name
]

{ #category : 'accessing' }
IGType >> reference [

	^ reference
]

{ #category : 'accessing' }
IGType >> reference: aTypeReference [

	reference := aTypeReference

]
