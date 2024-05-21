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

{ #category : 'testing' }
CigTypedef >> isHomonym [
	"this answer true if this is a structure/enum that typedefs a structure/enum. 
	 e.g 
		typedef struct Vector2 Vector2
		typedef enum ConfigFlags ConfigFlags"
	
	^ self isHomonymStruct or: [ self isHomonymEnum ]
]

{ #category : 'private' }
CigTypedef >> isHomonymEnum [

	^ (self underlyingTypeName beginsWith: 'enum ')
		and: [ (self underlyingTypeName allButFirst: 5) = self name ]
]

{ #category : 'private' }
CigTypedef >> isHomonymStruct [

	^ (self underlyingTypeName beginsWith: 'struct ')
		and: [ (self underlyingTypeName allButFirst: 7) = self name ]
]

{ #category : 'accessing' }
CigTypedef >> phDeclaration [

	"typedef will be generated as itself (no prefix, since is not a class)"
	^ self name
]
