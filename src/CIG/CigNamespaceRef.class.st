Class {
	#name : 'CigNamespaceRef',
	#superclass : 'CigReference',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigNamespaceRef class >> kind [
	
	^ CXCursor_NamespaceRef
]

{ #category : 'visiting' }
CigNamespaceRef >> accept: aVisitor [
	
]

{ #category : 'testing' }
CigNamespaceRef >> isNamespaceReference [

	^ true
]
