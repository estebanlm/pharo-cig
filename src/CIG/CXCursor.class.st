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

{ #category : 'accessing - arguments' }
CXCursor >> argumentAt: index [

	^ self ffiCall: #(CXCursor clang_Cursor_getArgument(CXCursor self, uint index))
]

{ #category : 'accessing - arguments' }
CXCursor >> arguments [

	^ Array streamContents: [ :stream |
		0 to: self numArguments - 1 do: [ :index |
			stream nextPut: (self argumentAt: index) ] ]
]

{ #category : 'private' }
CXCursor >> clang_Cursor_getRawCommentText [

	self ffiCall: #(CXString clang_Cursor_getRawCommentText(CXCursor self))
]

{ #category : 'private' }
CXCursor >> clang_Cursor_isNull [

	self ffiCall: #(Boolean clang_Cursor_isNull(CXCursor self))
]

{ #category : 'private' }
CXCursor >> clang_getCursorDisplayName [

	^ self ffiCall: #(CXString clang_getCursorDisplayName(CXCursor self))
]

{ #category : 'private' }
CXCursor >> clang_getCursorExtent [

	^ self ffiCall: #(CXSourceRange clang_getCursorExtent(CXCursor self))
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
CXCursor >> clang_getCursorSemanticParent [

	self ffiCall: #(CXCursor clang_getCursorSemanticParent(CXCursor self))
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

{ #category : 'accessing - method' }
CXCursor >> cxxAccessSpecifier [
	
	self ffiCall: #("enum CX_CXXAccessSpecifier"int clang_getCXXAccessSpecifier(CXCursor self))
]

{ #category : 'testing' }
CXCursor >> cxxMethodIsPureVirtual [

	self source ifNotNil: [ :aString | 
		^ aString endsWith: '0' ].
	
	^ false
]

{ #category : 'testing' }
CXCursor >> cxxMethodIsVirtual [

	^ self ffiCall: #(Boolean clang_CXXMethod_isVirtual(CXCursor self))
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
CXCursor >> equalTo: aCursor [

	^ self ffiCall: #(Boolean clang_equalCursors(CXCursor self	, CXCursor aCursor))
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
CXCursor >> isFunctionInlined [

	^ self ffiCall: #(Boolean clang_Cursor_isFunctionInlined(CXCursor self))
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

{ #category : 'accessing - arguments' }
CXCursor >> numArguments [

	^ self ffiCall: #(int clang_Cursor_getNumArguments(CXCursor self))
]

{ #category : 'accessing - overloaded' }
CXCursor >> numOverloadedDecls [
	
	^ self ffiCall: #(uint clang_getNumOverloadedDecls(CXCursor self))
]

{ #category : 'accessing - overloaded' }
CXCursor >> overloadedDeclarationAt: index [

	^ self ffiCall: #(CXCursor clang_getOverloadedDecl(CXCursor self, uint index))
]

{ #category : 'accessing - overloaded' }
CXCursor >> overloadedDeclarations [

	^ Array streamContents: [ :stream | 
		0 to: self numOverloadedDecls - 1 do: [ :index | 
			stream nextPut: (self overloadedDeclarationAt: index) ] ]
]

{ #category : 'accessing' }
CXCursor >> parent [
	| parent |
	
	parent := self clang_getCursorSemanticParent.
	^ (parent clang_Cursor_isNull)
		ifTrue: [ nil ]
		ifFalse: [ parent ]
]

{ #category : 'accessing' }
CXCursor >> rawComment [
	| string |
	
	string := self clang_Cursor_getRawCommentText.
	^ [ string cString ]
		ensure: [ string dispose ]
]

{ #category : 'accessing - templates' }
CXCursor >> referenced [

	^ self ffiCall: #(CXCursor clang_getCursorReferenced(CXCursor self)) 	
]

{ #category : 'accessing' }
CXCursor >> source [
	| fileName pos range size source |
	
	fileName := self location fileName.
	fileName ifEmpty: [ ^ nil ].
	 
	range := self clang_getCursorExtent.	
	pos := range start offset.
	size := range end offset - pos.
	fileName asFileReference readStreamDo: [ :stream |
		stream position: pos.
		source := stream next: size ].
	^ source trimmed
]

{ #category : 'accessing' }
CXCursor >> spelling [
	| string |
	
	string := self clang_getCursorSpelling.
	^ [ string cString ]
		ensure: [ string dispose ]
]

{ #category : 'accessing - templates' }
CXCursor >> templateKind [

	self ffiCall: #(int clang_getTemplateCursorKind(CXCursor self))
]

{ #category : 'accessing' }
CXCursor >> type [

	^ self ffiCall: #(CXType clang_getCursorType(CXCursor self))
]

{ #category : 'accessing - typedef' }
CXCursor >> typedefDeclUnderlyingType [

	self ffiCall: #(CXType clang_getTypedefDeclUnderlyingType(CXCursor self))
]

{ #category : 'visiting' }
CXCursor >> visitChildren: aBlock [
	| callback |
	
	callback := CXCallback 
		signature: #(int (CXCursor current, CXCursor parent, void *data)) 
		block: aBlock.
		
	^ self clang_visitChildren: callback
]

{ #category : 'accessing' }
CXCursor >> withAllParents [
	| parents current |
	
	parents := OrderedCollection new.
	current := self.
	[ current notNil and: [ current clang_Cursor_isNull not ] ] 
	whileTrue: [ 
		parents add: current.
		current := current parent ].
	
	^ parents reversed
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
