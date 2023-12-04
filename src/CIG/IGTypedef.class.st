Class {
	#name : 'IGTypedef',
	#superclass : 'IGElement',
	#instVars : [
		'underlyingTypeKind',
		'underlyingTypeSpelling',
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
IGTypedef class >> kind [
	
	^ CXCursor_TypedefDecl
]

{ #category : 'visiting' }
IGTypedef >> accept: aVisitor [
	
	aVisitor visitTypedef: self
]

{ #category : 'testing' }
IGTypedef >> definesFunction [

	^ definesFunction
]

{ #category : 'initialization' }
IGTypedef >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor typedefDeclUnderlyingType.
	underlyingTypeSpelling := type spelling.
	underlyingTypeKind := type kind.
	definesFunction := underlyingTypeKind = CXType_Pointer 
		and: [ type pointeeType resultType ~= CXType_Invalid ]
]

{ #category : 'accessing' }
IGTypedef >> resolveType [
	
	^ IGTypedefType new
		parent: self;
		name: self name;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
IGTypedef >> spelling [
]

{ #category : 'accessing' }
IGTypedef >> underlyingTypeKind [

	^ underlyingTypeKind
]

{ #category : 'accessing' }
IGTypedef >> underlyingTypeSpelling [

	^ underlyingTypeSpelling
]