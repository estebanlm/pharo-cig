Class {
	#name : 'CigVariable',
	#superclass : 'CigElement',
	#instVars : [
		'typeName',
		'typeKind'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigVariable class >> kind [

	^ CXCursor_VarDecl
]

{ #category : 'visiting' }
CigVariable >> accept: aVisitor [

	aVisitor visitVariable: self
]

{ #category : 'initialization' }
CigVariable >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor type.
	typeName := type spelling.
	typeKind := type kind	
]

{ #category : 'testing' }
CigVariable >> isStructMember [

	^ true
]

{ #category : 'testing' }
CigVariable >> isVariable [

	^ true
]

{ #category : 'accessing' }
CigVariable >> resolveType [
	
	^ CigType new 
		parent: self;
		name: self typeName;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
CigVariable >> typeKind [

	^ typeKind
]

{ #category : 'accessing' }
CigVariable >> typeName [

	^ typeName
]
