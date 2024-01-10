Class {
	#name : 'CigBaseTypedef',
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
CigBaseTypedef class >> kind [
	
	^ nil
]

{ #category : 'visiting' }
CigBaseTypedef >> accept: aVisitor [
	
	aVisitor visitTypedef: self
]

{ #category : 'accessing' }
CigBaseTypedef >> cTemplate [
	
	^ CigCTypedefTemplate for: self
]

{ #category : 'testing' }
CigBaseTypedef >> definesArray [

	^ definesArray
]

{ #category : 'testing' }
CigBaseTypedef >> definesFunction [

	^ definesFunction
]

{ #category : 'initialization' }
CigBaseTypedef >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor typedefDeclUnderlyingType.
	underlyingTypeSpelling := type spelling.
	underlyingTypeKind := type kind.
	definesFunction := (underlyingTypeSpelling beginsWith: 'std::function') 
		or: [ (underlyingTypeKind = CXType_Pointer 
			and: [ type pointeeType resultType ~= CXType_Invalid ]) ].
	definesArray := underlyingTypeKind = CXType_ConstantArray 
			or: [ underlyingTypeKind = CXType_IncompleteArray
			or: [ underlyingTypeKind = CXType_VariableArray ] ]
]

{ #category : 'testing' }
CigBaseTypedef >> isTypedef [

	^ true
]

{ #category : 'accessing' }
CigBaseTypedef >> phTemplate [
	
	^ CigPharoTypedefTemplate for: self
]

{ #category : 'accessing' }
CigBaseTypedef >> resolveType [
	
	^ CigType new
		parent: self;
		name: self name;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
CigBaseTypedef >> spelling [
]

{ #category : 'accessing' }
CigBaseTypedef >> underlyingTypeKind [

	^ underlyingTypeKind
]

{ #category : 'accessing' }
CigBaseTypedef >> underlyingTypeName [

	^ underlyingTypeSpelling
]
