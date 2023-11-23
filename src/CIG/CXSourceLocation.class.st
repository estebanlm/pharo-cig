Class {
	#name : 'CXSourceLocation',
	#superclass : 'CXStructure',
	#classVars : [
		'OFFSET_INT_DATA',
		'OFFSET_PTR_DATA_1',
		'OFFSET_PTR_DATA_2'
	],
	#category : 'CIG-LibClang',
	#package : 'CIG',
	#tag : 'LibClang'
}

{ #category : 'field definition' }
CXSourceLocation class >> fieldsDesc [

	^ #(
 	void *ptr_data_1;
	void *ptr_data_2;
   	uint int_data;	
	)
]

{ #category : 'private' }
CXSourceLocation >> clang_Location_isInSystemHeader [

 	^ self ffiCall: #(int clang_Location_isInSystemHeader(CXSourceLocation self)) 
]

{ #category : 'accessing - structure variables' }
CXSourceLocation >> int_data [
	"This method was automatically generated"
	^handle unsignedLongAt: OFFSET_INT_DATA
]

{ #category : 'accessing - structure variables' }
CXSourceLocation >> int_data: anObject [
	"This method was automatically generated"
	handle unsignedLongAt: OFFSET_INT_DATA put: anObject
]

{ #category : 'testing' }
CXSourceLocation >> isInSystemHeader [

	^ self clang_Location_isInSystemHeader ~= 0
]

{ #category : 'accessing - structure variables' }
CXSourceLocation >> ptr_data_1 [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_PTR_DATA_1) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXSourceLocation >> ptr_data_1: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_PTR_DATA_1 put: anObject getHandle.
]

{ #category : 'accessing - structure variables' }
CXSourceLocation >> ptr_data_2 [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_PTR_DATA_2) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXSourceLocation >> ptr_data_2: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_PTR_DATA_2 put: anObject getHandle.
]
