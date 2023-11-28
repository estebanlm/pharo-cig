Class {
	#name : 'CXType',
	#superclass : 'CXStructure',
	#classVars : [
		'OFFSET_DATA_1',
		'OFFSET_DATA_2',
		'OFFSET_KIND'
	],
	#pools : [
		'CXTypeKind'
	],
	#category : 'CIG-LibClang',
	#package : 'CIG',
	#tag : 'LibClang'
}

{ #category : 'field definition' }
CXType class >> fieldsDesc [

	^ #(
	int kind;
	void *data_1;
	void *data_2;
	)
]

{ #category : 'private' }
CXType >> clang_getTypeKindSpelling: kind [

	^ self ffiCall: #(CXString clang_getTypeKindSpelling(int kind))
]

{ #category : 'private' }
CXType >> clang_getTypeSpelling [

	^ self ffiCall: #(CXString clang_getTypeSpelling(CXType self))
]

{ #category : 'accessing - structure variables' }
CXType >> data_1 [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_DATA_1) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXType >> data_1: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DATA_1 put: anObject getHandle.
]

{ #category : 'accessing - structure variables' }
CXType >> data_2 [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_DATA_2) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXType >> data_2: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DATA_2 put: anObject getHandle.
]

{ #category : 'testing' }
CXType >> isEnum [

	^ self kind = CXType_Enum
]

{ #category : 'accessing - structure variables' }
CXType >> kind [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_KIND
]

{ #category : 'accessing - structure variables' }
CXType >> kind: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_KIND put: anObject
]

{ #category : 'accessing' }
CXType >> kindSpelling [
	| string |
	
	string := self clang_getTypeKindSpelling: self kind.
	^ [ string cString ]
		ensure: [ string dispose ]
]

{ #category : 'accessing' }
CXType >> resultType [

	^ self ffiCall: #(CXType clang_getResultType(CXType self))
]

{ #category : 'accessing' }
CXType >> spelling [
	| string |
	
	string := self clang_getTypeSpelling.
	^ [ string cString ]
		ensure: [ string dispose ]
]

{ #category : 'accessing' }
CXType >> typeDeclaration [

	^ self ffiCall: #(CXCursor clang_getTypeDeclaration(CXType self))
]
