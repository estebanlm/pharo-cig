Class {
	#name : 'CXSourceLocation',
	#superclass : 'CXStructure',
	#classVars : [
		'OFFSET_INT_DATA',
		'OFFSET_PTR_DATA_1',
		'OFFSET_PTR_DATA_2'
	],
	#category : 'CIG-LibClang',
	#package : 'CIG-LibClang'
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

{ #category : 'private' }
CXSourceLocation >> clang_getSpellingLocationFile: file line: line column: column offset: offset [

	self ffiCall: #(void clang_getSpellingLocation(
		CXSourceLocation self,
		"CXFile *"void *file,
		"unsigned *"uint *line,
		"unsigned *"uint *column,
		"unsigned *"uint *offset 
	))
]

{ #category : 'accessing' }
CXSourceLocation >> fileName [
	| buffer file |

	buffer := FFIOop newBuffer.
	self 
		clang_getSpellingLocationFile: buffer 
		line: ExternalAddress null 
		column: ExternalAddress null
		offset: ExternalAddress null.
		
	file := CXFile fromHandle: (buffer pointerAt: 1).
	^ file fileName
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

{ #category : 'accessing' }
CXSourceLocation >> offset [
	| buffer |

	buffer := FFIUInt32 newBuffer.
	self 
		clang_getSpellingLocationFile: ExternalAddress null 
		line: ExternalAddress null 
		column: ExternalAddress null
		offset: buffer.
		
	^ buffer unsignedLongAt: 1
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
