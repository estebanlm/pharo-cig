Class {
	#name : 'IGEnum',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGEnum class >> kind [

	^ CXCursor_EnumDecl
]

{ #category : 'accessing' }
IGEnum class >> typeReferenceName [
	"prefix included in IGTypeReference"
	
	^ 'enum'
]

{ #category : 'visiting' }
IGEnum >> accept: aVisitor [

	aVisitor visitEnum: self
]

{ #category : 'accessing' }
IGEnum >> cTemplate [

	^ IGCEnumTemplate for: self
]

{ #category : 'testing' }
IGEnum >> isEnum [

	^ true
]

{ #category : 'testing' }
IGEnum >> isUnnamed [

	^ self name beginsWith: '(unnamed enum'
]

{ #category : 'accessing' }
IGEnum >> resolveType [

	^ IGEnumType new 
		parent: self;
		name: self name;
		yourself
]
