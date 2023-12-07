Class {
	#name : 'IGVariable',
	#superclass : 'IGElement',
	#instVars : [
		'typeName',
		'typeKind'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGVariable class >> kind [

	^ CXCursor_VarDecl
]

{ #category : 'visiting' }
IGVariable >> accept: aVisitor [

	aVisitor visitVariable: self
]

{ #category : 'initialization' }
IGVariable >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor type.
	typeName := type spelling.
	typeKind := type kind	
]

{ #category : 'testing' }
IGVariable >> isVariable [

	^ true
]

{ #category : 'accessing' }
IGVariable >> resolveType [
	
	^ IGType new 
		parent: self;
		name: self typeName;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
IGVariable >> typeKind [

	^ typeKind
]

{ #category : 'accessing' }
IGVariable >> typeName [

	^ typeName
]
