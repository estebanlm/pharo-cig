Class {
	#name : 'CXToken',
	#superclass : 'CXStructure',
	#instVars : [
		'kind'
	],
	#classVars : [
		'OFFSET_INT_DATA_1',
		'OFFSET_INT_DATA_2',
		'OFFSET_INT_DATA_3',
		'OFFSET_INT_DATA_4',
		'OFFSET_PTR_DATA'
	],
	#pools : [
		'CXTokenKind'
	],
	#category : 'CIG-LibClang',
	#package : 'CIG-LibClang'
}

{ #category : 'field definition' }
CXToken class >> fieldsDesc [
	"self rebuildFieldAccessors"

	^ #(
	uint int_data_1
	uint int_data_2
	uint int_data_3
	uint int_data_4
	void *ptr_data
	)
]

{ #category : 'private' }
CXToken >> basicKind [

	^ self ffiCall: #(int clang_getTokenKind (CXToken self))
]

{ #category : 'accessing - structure variables' }
CXToken >> int_data_1 [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_INT_DATA_1
]

{ #category : 'accessing - structure variables' }
CXToken >> int_data_1: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_INT_DATA_1 put: anObject
]

{ #category : 'accessing - structure variables' }
CXToken >> int_data_2 [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_INT_DATA_2
]

{ #category : 'accessing - structure variables' }
CXToken >> int_data_2: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_INT_DATA_2 put: anObject
]

{ #category : 'accessing - structure variables' }
CXToken >> int_data_3 [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_INT_DATA_3
]

{ #category : 'accessing - structure variables' }
CXToken >> int_data_3: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_INT_DATA_3 put: anObject
]

{ #category : 'accessing - structure variables' }
CXToken >> int_data_4 [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_INT_DATA_4
]

{ #category : 'accessing - structure variables' }
CXToken >> int_data_4: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_INT_DATA_4 put: anObject
]

{ #category : 'testing' }
CXToken >> isComment [

	^ self kind = CXToken_Comment
]

{ #category : 'testing' }
CXToken >> isIdentifier [

	^ self kind = CXToken_Identifier
]

{ #category : 'testing' }
CXToken >> isKeyword [

	^ self kind = CXToken_Keyword
]

{ #category : 'testing' }
CXToken >> isLiteral [

	^ self kind = CXToken_Literal
]

{ #category : 'testing' }
CXToken >> isPunctuation [

	^ self kind = CXToken_Punctuation
]

{ #category : 'accessing' }
CXToken >> kind [

	^ kind ifNil: [ kind := self basicKind ]
]

{ #category : 'accessing - structure variables' }
CXToken >> ptr_data [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_PTR_DATA) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXToken >> ptr_data: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_PTR_DATA put: anObject getHandle.
]
