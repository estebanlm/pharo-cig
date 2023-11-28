Class {
	#name : 'CXSourceRange',
	#superclass : 'CXStructure',
	#classVars : [
		'OFFSET_BEGIN_INT_DATA',
		'OFFSET_END_INT_DATA',
		'OFFSET_PTR_DATA_1',
		'OFFSET_PTR_DATA_2'
	],
	#category : 'CIG-LibClang',
	#package : 'CIG',
	#tag : 'LibClang'
}

{ #category : 'field definition' }
CXSourceRange class >> fieldsDesc [

	^ #(
	void *ptr_data_1;
	void *ptr_data_2;
  	uint begin_int_data;
  	uint end_int_data;
	)
]

{ #category : 'accessing - structure variables' }
CXSourceRange >> begin_int_data [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_BEGIN_INT_DATA
]

{ #category : 'accessing - structure variables' }
CXSourceRange >> begin_int_data: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_BEGIN_INT_DATA put: anObject
]

{ #category : 'accessing' }
CXSourceRange >> end [

	^ self ffiCall: #(CXSourceLocation clang_getRangeEnd(CXSourceRange self))
]

{ #category : 'accessing - structure variables' }
CXSourceRange >> end_int_data [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_END_INT_DATA
]

{ #category : 'accessing - structure variables' }
CXSourceRange >> end_int_data: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_END_INT_DATA put: anObject
]

{ #category : 'accessing - structure variables' }
CXSourceRange >> ptr_data_1 [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_PTR_DATA_1) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXSourceRange >> ptr_data_1: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_PTR_DATA_1 put: anObject getHandle.
]

{ #category : 'accessing - structure variables' }
CXSourceRange >> ptr_data_2 [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_PTR_DATA_2) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXSourceRange >> ptr_data_2: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_PTR_DATA_2 put: anObject getHandle.
]

{ #category : 'accessing' }
CXSourceRange >> start [

	^ self ffiCall: #(CXSourceLocation clang_getRangeStart(CXSourceRange self))
]
