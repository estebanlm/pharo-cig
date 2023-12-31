Class {
	#name : 'IGField',
	#superclass : 'IGElement',
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
IGField class >> kind [
	
	^ CXCursor_FieldDecl
]

{ #category : 'visiting' }
IGField >> accept: aVisitor [

	"Fields are handled by their parents"
]

{ #category : 'initialization' }
IGField >> fromCursor: aCursor [
	| type |

	super fromCursor: aCursor.
	type := aCursor type.
	typeName := type spelling.
	typeKind := type kind.
	isPublic := aCursor cxxAccessSpecifier = 1
]

{ #category : 'testing' }
IGField >> isField [

	^ true
]

{ #category : 'testing' }
IGField >> isPublic [

	^ isPublic
]

{ #category : 'accessing' }
IGField >> resolveType [
	
	^ IGType new 
		parent: self;
		name: self typeName;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
IGField >> typeKind [

	^ typeKind
]

{ #category : 'accessing' }
IGField >> typeName [

	^ typeName
]
