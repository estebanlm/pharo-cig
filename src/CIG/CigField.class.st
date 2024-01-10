Class {
	#name : 'CigField',
	#superclass : 'CigElement',
	#instVars : [
		'typeName',
		'typeKind',
		'isPublic'
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

{ #category : 'initialization' }
CigField >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor type.
	typeName := type spelling.
	typeKind := type kind.
	isPublic := aCursor isPublic
]

{ #category : 'testing' }
CigField >> isField [

	^ true
]

{ #category : 'testing' }
CigField >> isPublic [

	^ isPublic
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
