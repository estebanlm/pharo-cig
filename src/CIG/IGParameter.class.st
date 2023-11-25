Class {
	#name : 'IGParameter',
	#superclass : 'IGElement',
	#instVars : [
		'typeName',
		'typeKind'
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
	"parameters are taken by their parent"
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
	
	element := self root findElementMatching: [ :each | each name = self typeName ].
	element ifNotNil: [
		"if elaborated element is an enum. we will need a cast"
		element isEnum ifTrue: [ ^ element fullName ].
		self flag: #TODO. "I need to complete with other elaborated types" ].

	"this is actually not a cast, but well... :P"
	^ self typeName
]

{ #category : 'initialization' }
IGParameter >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor type.
	typeName := type spelling.
	typeKind := type kind
]

{ #category : 'testing' }
IGParameter >> isElaborated [

	^ self typeKind = CXType_Elaborated
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
