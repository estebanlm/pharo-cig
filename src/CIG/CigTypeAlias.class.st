Class {
	#name : 'CigTypeAlias',
	#superclass : 'CigElement',
	#classTraits : '{} + TraitedClass',
	#instVars : [
		'elaboratedSpec'
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
]

{ #category : 'initialization' }
CigTypeAlias >> fromCursor: aCursor [
	
	super fromCursor: aCursor.
	elaboratedSpec := CigElaboratedTypeSpec fromType: aCursor typedefDeclUnderlyingType
]

{ #category : 'accessing' }
CigTypeAlias >> underlyingTypeKind [

	^ elaboratedSpec ifNotNil: #underlyingTypeKind
]

{ #category : 'accessing' }
CigTypeAlias >> underlyingTypeSpelling [

	^ elaboratedSpec ifNotNil: #underlyingTypeSpelling
]
