Class {
	#name : 'IGNamespaceRef',
	#superclass : 'IGReference',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGNamespaceRef class >> kind [
	
	^ CXCursor_NamespaceRef
]

{ #category : 'visiting' }
IGNamespaceRef >> accept: aVisitor [
	
]
