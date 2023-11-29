Class {
	#name : 'IGField',
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
	typeKind := type kind	
]

{ #category : 'testing' }
IGField >> isField [

	^ true
]

{ #category : 'accessing' }
IGField >> resolveType [
	
	^ IGType new 
		parent: self;
		name: self typeName;
		reference: self typeReference;
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
