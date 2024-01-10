Class {
	#name : 'CigTypedef',
	#superclass : 'CigBaseTypedef',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigTypedef class >> kind [
	
	^ CXCursor_TypedefDecl
]

{ #category : 'accessing' }
CigTypedef class >> typeKind [
	
	^ CXType_Typedef
]
