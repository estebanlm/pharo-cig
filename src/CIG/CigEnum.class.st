Class {
	#name : 'CigEnum',
	#superclass : 'CigElement',
	#instVars : [
		'isPublic'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigEnum class >> kind [

	^ CXCursor_EnumDecl
]

{ #category : 'accessing' }
CigEnum class >> typeReferenceName [
	"prefix included in IGTypeReference"
	
	^ 'enum'
]

{ #category : 'visiting' }
CigEnum >> accept: aVisitor [

	aVisitor visitEnum: self
]

{ #category : 'accessing' }
CigEnum >> cTemplate [

	^ CigCEnumTemplate for: self
]

{ #category : 'initialization' }
CigEnum >> fromCursor: aCursor [

	super fromCursor: aCursor.
	isPublic := aCursor isPublic
]

{ #category : 'testing' }
CigEnum >> isAnonymous [
	
	^ self name beginsWith: '(unnamed'
]

{ #category : 'testing' }
CigEnum >> isEnum [

	^ true
]

{ #category : 'testing' }
CigEnum >> isPublic [

	^ self parent isPublic: self
]

{ #category : 'testing' }
CigEnum >> isUnnamed [

	^ self name beginsWith: '(unnamed enum'
]

{ #category : 'accessing' }
CigEnum >> phTemplate [

	^ CigPharoEnumerationTemplate for: self
]

{ #category : 'accessing' }
CigEnum >> resolveType [

	^ CigType new 
		parent: self;
		name: self name;
		yourself
]
