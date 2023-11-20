Class {
	#name : 'CXCursor',
	#superclass : 'FFIExternalStructure',
	#traits : 'TLibClang',
	#classTraits : 'TLibClang classTrait',
	#classVars : [
		'OFFSET_DATA_1',
		'OFFSET_DATA_2',
		'OFFSET_DATA_3',
		'OFFSET_KIND',
		'OFFSET_XDATA'
	],
	#category : 'LibClang',
	#package : 'LibClang'
}

{ #category : 'field definition' }
CXCursor class >> fieldsDesc [
	"self rebuildFieldAccessors"

	^ #(
  "enum CXCursorKind"int kind;
  int xdata;
  void *data_1;	
  void *data_2;	
  void *data_3;	
	)
]

{ #category : 'instance creation' }
CXCursor class >> newTranslationUnit: tu [

	^ self ffiCall: #(void *clang_getTranslationUnitCursor(CXTranslationUnit tu))
]

{ #category : 'private' }
CXCursor >> clang_visitChildren: visitor [

	^ self ffiCall: #(uint clang_visitChildren(
		self,
		FFICallback visitor,
		NULL))
]

{ #category : 'accessing - structure variables' }
CXCursor >> data_1 [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_DATA_1) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXCursor >> data_1: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DATA_1 put: anObject getHandle.
]

{ #category : 'accessing - structure variables' }
CXCursor >> data_2 [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_DATA_2) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXCursor >> data_2: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DATA_2 put: anObject getHandle.
]

{ #category : 'accessing - structure variables' }
CXCursor >> data_3 [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_DATA_3) type: ExternalType void asPointerType
]

{ #category : 'accessing - structure variables' }
CXCursor >> data_3: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DATA_3 put: anObject getHandle.
]

{ #category : 'accessing - structure variables' }
CXCursor >> kind [
	"This method was automatically generated"
	^handle signedLongLongAt: OFFSET_KIND
]

{ #category : 'accessing - structure variables' }
CXCursor >> kind: anObject [
	"This method was automatically generated"
	handle signedLongLongAt: OFFSET_KIND put: anObject
]

{ #category : 'visiting' }
CXCursor >> visitChildren: aBlock [
	| callback |
	
	callback := CXCallback 
		signature: #(int (CXCursor current, CXCursor parent, void *data)) 
		block: aBlock.
		
	^ self clang_visitChildren: callback
]

{ #category : 'accessing - structure variables' }
CXCursor >> xdata [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_XDATA
]

{ #category : 'accessing - structure variables' }
CXCursor >> xdata: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_XDATA put: anObject
]
