Class {
	#name : 'CigUnion',
	#superclass : 'CigStructure',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigUnion class >> kind [

	^ CXCursor_UnionDecl
]

{ #category : 'accessing' }
CigUnion class >> typeReferenceName [
	"prefix included in IGTypeReference"
	
	^ 'union'
]

{ #category : 'visiting' }
CigUnion >> accept: aVisitor [

	aVisitor visitUnion: self
]

{ #category : 'accessing' }
CigUnion >> cTemplate [
	
	^ CigCUnionTemplate for: self
]

{ #category : 'testing' }
CigUnion >> isUnion [

	^ true
]

{ #category : 'accessing' }
CigUnion >> phTemplate [
	
	^ CigPharoUnionTemplate for: self
]
