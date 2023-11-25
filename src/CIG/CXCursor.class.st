Class {
	#name : 'CXCursor',
	#superclass : 'CXStructure',
	#classTraits : 'TLibClang classTrait',
	#classVars : [
		'OFFSET_DATA_1',
		'OFFSET_DATA_2',
		'OFFSET_DATA_3',
		'OFFSET_KIND',
		'OFFSET_XDATA'
	],
	#pools : [
		'CXCursorKind'
	],
	#category : 'CIG-LibClang',
	#package : 'CIG',
	#tag : 'LibClang'
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
CXCursor >> clang_getCursorDisplayName [

	^ self ffiCall: #(CXString clang_getCursorDisplayName(CXCursor self))
]

{ #category : 'private' }
CXCursor >> clang_getCursorKindSpelling: kind [

	self ffiCall: #(CXString clang_getCursorKindSpelling(int kind))
]

{ #category : 'private' }
CXCursor >> clang_getCursorLocation [

	self ffiCall: #(CXSourceLocation clang_getCursorLocation(CXCursor self))
]

{ #category : 'private' }
CXCursor >> clang_getCursorSpelling [

	self ffiCall: #(CXString clang_getCursorSpelling(CXCursor self))
]

{ #category : 'private' }
CXCursor >> clang_visitChildren: visitor [

	^ self ffiCall: #(uint clang_visitChildren(
		CXCursor self,
		FFICallback visitor,
		NULL))
]

{ #category : 'accessing' }
CXCursor >> cxxAccessSpecifier [
	
	self ffiCall: #("enum CX_CXXAccessSpecifier"int clang_getCXXAccessSpecifier(CXCursor self))
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

{ #category : 'accessing' }
CXCursor >> displayName [
	| string |
	
	string := self clang_getCursorDisplayName.
	^ [ string cString ]
		ensure: [ string dispose ]
]

{ #category : 'accessing' }
CXCursor >> enumConstantValue [

	^ self ffiCall: #(longlong clang_getEnumConstantDeclValue (CXCursor self))
]

{ #category : 'testing' }
CXCursor >> isEnumConstantDeclaration [

	^ self kind = CXCursor_EnumConstantDecl
]

{ #category : 'testing' }
CXCursor >> isEnumDeclaration [

	^ self kind = CXCursor_EnumDecl
]

{ #category : 'testing' }
CXCursor >> isFunctionDeclaration [

	^ self kind = CXCursor_FunctionDecl
]

{ #category : 'testing' }
CXCursor >> isNamespace [

	^ self kind = CXCursor_Namespace
]

{ #category : 'testing' }
CXCursor >> isParameterDeclaration [

	^ self kind = CXCursor_ParmDecl
]

{ #category : 'accessing' }
CXCursor >> kind [

	^ self ffiCall: #(int clang_getCursorKind(CXCursor self))
]

{ #category : 'accessing - structure variables' }
CXCursor >> kind: anObject [
	"This method was automatically generated"
	handle signedLongLongAt: OFFSET_KIND put: anObject
]

{ #category : 'accessing' }
CXCursor >> kindSpelling [
	| string |
	
	string := self clang_getCursorKindSpelling: self kind.
	^ [ string cString ]
		ensure: [ string dispose ]
]

{ #category : 'accessing' }
CXCursor >> location [

	^ self clang_getCursorLocation
]

{ #category : 'accessing' }
CXCursor >> spelling [
	| string |
	
	string := self clang_getCursorSpelling.
	^ [ string cString ]
		ensure: [ string dispose ]
]

{ #category : 'accessing' }
CXCursor >> type [

	^ self ffiCall: #(CXType clang_getCursorType(CXCursor self))
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
