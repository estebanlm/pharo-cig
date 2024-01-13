Class {
	#name : 'CigTypeAlias',
	#superclass : 'CigBaseTypedef',
	#classTraits : '{} + TraitedClass',
	#instVars : [
		'isPublic'
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

	super fromCursor: aCursor.
	isPublic := aCursor isPublic
]

{ #category : 'nil' }
CigTypeAlias >> isPublic [

	^ isPublic
]
