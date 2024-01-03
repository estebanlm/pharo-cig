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
CigUnion >> phTemplate [
	
	^ CigPharoUnionTemplate for: self
]
