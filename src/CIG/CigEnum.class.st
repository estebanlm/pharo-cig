Class {
	#name : 'CigEnum',
	#superclass : 'CigElement',
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

{ #category : 'testing' }
CigEnum >> isEnum [

	^ true
]

{ #category : 'testing' }
CigEnum >> isUnnamed [

	^ self name beginsWith: '(unnamed enum'
]

{ #category : 'accessing' }
CigEnum >> resolveType [

	^ CigEnumType new 
		parent: self;
		name: self name;
		yourself
]
