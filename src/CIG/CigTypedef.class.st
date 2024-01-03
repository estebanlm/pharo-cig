Class {
	#name : 'CigTypedef',
	#superclass : 'CigElement',
	#instVars : [
		'underlyingTypeKind',
		'underlyingTypeSpelling',
		'definesFunction',
		'definesArray'
	],
	#pools : [
		'CXTypeKind'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigTypedef class >> kind [
	
	^ CXCursor_TypedefDecl
]

{ #category : 'accessing' }
CigTypedef class >> typeKind [
	
	^ CXType_Typedef
]

{ #category : 'visiting' }
CigTypedef >> accept: aVisitor [
	
	aVisitor visitTypedef: self
]

{ #category : 'accessing' }
CigTypedef >> cTemplate [
	
	^ CigCTypedefTemplate for: self
]

{ #category : 'testing' }
CigTypedef >> definesArray [

	^ definesArray
]

{ #category : 'testing' }
CigTypedef >> definesFunction [

	^ definesFunction
]

{ #category : 'initialization' }
CigTypedef >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor typedefDeclUnderlyingType.
	underlyingTypeSpelling := type spelling.
	underlyingTypeKind := type kind.
	definesFunction := underlyingTypeKind = CXType_Pointer 
		and: [ type pointeeType resultType ~= CXType_Invalid ].
	definesArray := underlyingTypeKind = CXType_ConstantArray 
			or: [ underlyingTypeKind = CXType_IncompleteArray
			or: [ underlyingTypeKind = CXType_VariableArray ] ]
]

{ #category : 'testing' }
CigTypedef >> isTypedef [

	^ true
]

{ #category : 'accessing' }
CigTypedef >> resolveType [
	
	^ CigTypedefType new
		parent: self;
		name: self name;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
CigTypedef >> spelling [
]

{ #category : 'accessing' }
CigTypedef >> underlyingTypeKind [

	^ underlyingTypeKind
]

{ #category : 'accessing' }
CigTypedef >> underlyingTypeName [

	^ underlyingTypeSpelling
]
