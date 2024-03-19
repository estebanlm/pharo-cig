Class {
	#name : 'CigField',
	#superclass : 'CigElement',
	#classTraits : '{} + TraitedClass',
	#instVars : [
		'typeName',
		'typeKind',
		'isPublic',
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
CigField class >> kind [
	
	^ CXCursor_FieldDecl
]

{ #category : 'visiting' }
CigField >> accept: aVisitor [

	"Fields are handled by their parents"
]

{ #category : 'accessing' }
CigField >> cTemplate [

	^ CigCParameterTemplate forField: self
]

{ #category : 'testing' }
CigField >> canBeFieldOfStructure [
	| type |

	type := self resolveType.
	"WARNING: do not invert isPointer and isClass check, it can generare an
	 infinite loop (in case of structures link linked lists, etc.)"
	^ type isSpecial not 
		and: [ (type isPointer not and: [ type isClass ]) not ]
]

{ #category : 'testing' }
CigField >> definesFunction [

	^ definesFunction
]

{ #category : 'initialization' }
CigField >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor type.
	typeName := type spelling.
	typeKind := type kind.
	isPublic := aCursor isPublic.
	definesFunction := ({ CXType_Pointer. CXType_LValueReference } includes: typeKind)
		and: [ { CXType_FunctionProto. CXType_FunctionNoProto } includes: type pointeeType kind ].		
	
]

{ #category : 'testing' }
CigField >> isField [

	^ true
]

{ #category : 'testing' }
CigField >> isPublic [

	^ self parent isPublic: self
]

{ #category : 'testing' }
CigField >> isSpecial [
	
	^ self resolveType isSpecial
]

{ #category : 'testing' }
CigField >> isStructMember [

	^ true
]

{ #category : 'accessing' }
CigField >> phTemplate [
	
	^ CigPharoFieldTemplate for: self
]

{ #category : 'accessing' }
CigField >> resolveType [
	
	^ CigType new 
		parent: self;
		name: self typeName;
		typeReference: self typeReference;
		definesFunction: self definesFunction;
		yourself
]

{ #category : 'accessing' }
CigField >> typeKind [

	^ typeKind
]

{ #category : 'accessing' }
CigField >> typeName [

	^ typeName
]
