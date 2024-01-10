Class {
	#name : 'CigTypeAlias',
	#superclass : 'CigElement',
	#instVars : [
		'underlyingTypeSpelling',
		'underlyingTypeKind',
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
CigTypeAlias class >> kind [
	
	^ CXCursor_TypeAliasDecl
]

{ #category : 'visiting' }
CigTypeAlias >> accept: aVisitor [

	aVisitor visitAlias: self
]

{ #category : 'initialization' }
CigTypeAlias >> fromCursor: aCursor [
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

{ #category : 'accessing' }
CigTypeAlias >> underlyingTypeKind [

	^ underlyingTypeKind
]

{ #category : 'accessing' }
CigTypeAlias >> underlyingTypeSpelling [

	^ underlyingTypeSpelling
]
