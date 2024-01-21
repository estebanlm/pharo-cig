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

{ #category : 'instance creation' }
CigTypedef class >> newName: aName type: aTypeName [

	 ^ self new 
		fromName: aName typeName: aTypeName;
		yourself
		
]

{ #category : 'accessing' }
CigTypedef class >> typeKind [
	
	^ CXType_Typedef
]

{ #category : 'instance creation' }
CigTypedef >> fromName: aName typeName: aTypeName [

	name := aName.
	underlyingTypeName := aTypeName.
	definesFunction := false.
	definesArray := false
]
