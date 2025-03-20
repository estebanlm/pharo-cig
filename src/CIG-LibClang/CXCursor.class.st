Class {
	#name : 'CXCursor',
	#superclass : 'CXStructure',
	#classTraits : 'TLibClang classTrait',
	#instVars : [
		'displayName',
		'kind'
	],
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
	#package : 'CIG-LibClang'
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
CXCursor >> argumentIndex [

	^ self ffiCall: #(int clang_Cursor_getArgumentIndex(CXCursor self))
]

{ #category : 'accessing - arguments' }
CXCursor >> arguments [

	^ Array streamContents: [ :stream |
		0 to: self numArguments - 1 do: [ :index |
			stream nextPut: (self argumentAt: index) ] ]
]

{ #category : 'private' }
CXCursor >> basicDisplayName [
	| string readString |
	
	string := self clang_getCursorDisplayName.
	string isNull ifTrue: [ ^ nil ].
	
	readString := string cString.
	readString isEmptyOrNil 
		ifFalse: [ string dispose ].
	
	^ readString
]

{ #category : 'private' }
CXCursor >> basicKind [

	^ self ffiCall: #(int clang_getCursorKind(CXCursor self))
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
CXCursor >> clang_getCursorLexicalParent [

	self ffiCall: #(CXCursor clang_getCursorLexicalParent(CXCursor self))
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
CXCursor >> clang_getIncludedFile [

	^ self ffiCall: #(CXFile clang_getIncludedFile(CXCursor self))
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
CXCursor >> cxxMethodIsDeleted [

	^ self ffiCall: #(Boolean clang_CXXMethod_isDeleted(CXCursor self))
]

{ #category : 'testing' }
CXCursor >> cxxMethodIsPureVirtual [

	"self source ifNotNil: [ :aString | 
		^ aString endsWith: '0' ].
	
	^ false"
	^ self ffiCall: #(Boolean clang_CXXMethod_isPureVirtual(CXCursor self))
]

{ #category : 'testing' }
CXCursor >> cxxMethodIsStatic [

	^ self ffiCall: #(Boolean clang_CXXMethod_isStatic(CXCursor self))
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

	^ displayName ifNil: [ displayName := self basicDisplayName ]
]

{ #category : 'accessing' }
CXCursor >> enumConstantValue [

	^ self ffiCall: #(longlong clang_getEnumConstantDeclValue (CXCursor self))
]

{ #category : 'testing' }
CXCursor >> equalTo: aCursor [

	^ self ffiCall: #(Boolean clang_equalCursors(CXCursor self	, CXCursor aCursor))
]

{ #category : 'accessing - include' }
CXCursor >> includedFileName [

	^ self clang_getIncludedFile fileName
]

{ #category : 'testing' }
CXCursor >> isClass [

	^ self kind = CXCursor_ClassDecl
]

{ #category : 'testing' }
CXCursor >> isCursorDefinition [

	self ffiCall: #(Boolean clang_isCursorDefinition(CXCursor self))
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
CXCursor >> isGlobal [

	^ self kind = CXCursor_TranslationUnit
]

{ #category : 'testing' }
CXCursor >> isMacroBuiltin [

	^ self ffiCall: #(Boolean clang_Cursor_isMacroBuiltin(CXCursor self))
]

{ #category : 'testing' }
CXCursor >> isMacroFunctionLike [

	^ self ffiCall: #(Boolean clang_Cursor_isMacroFunctionLike(CXCursor self))
]

{ #category : 'testing' }
CXCursor >> isNamespace [

	^ self kind = CXCursor_Namespace
]

{ #category : 'testing' }
CXCursor >> isParameterDeclaration [

	^ self kind = CXCursor_ParmDecl
]

{ #category : 'testing' }
CXCursor >> isPublic [
	| parent |
	
	parent := self semanticParent.
	parent ifNil: [ ^ true ].
	
	^ parent isClass not or: [ self cxxAccessSpecifier = 1 ]
]

{ #category : 'testing' }
CXCursor >> isVariadic [

	^ self ffiCall: #(Boolean clang_Cursor_isVariadic(CXCursor self))
]

{ #category : 'accessing' }
CXCursor >> kind [

	^ kind ifNil: [ kind := self basicKind ]
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
CXCursor >> lexicalParent [
	| parent |
	
	parent := self clang_getCursorLexicalParent.
	^ (parent clang_Cursor_isNull)
		ifTrue: [ nil ]
		ifFalse: [ parent ]
]

{ #category : 'accessing' }
CXCursor >> lexicalPath [

	^ self withAllLexicalParents allButFirst 
		collect: [ :each | 
			| elementName |
			elementName := each displayName.
			each kind = CXCursor_ClassTemplate
				ifTrue: [ elementName := elementName copyUpTo: $< ].
			elementName ]
		as: Array
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

	self 
		deprecated: 'It is a bad name as it is not precise' 
		transformWith: '`@receiver parent' -> '`@receiver semanticParent'.
		
	^ self semanticParent
]

{ #category : 'accessing' }
CXCursor >> path [

	self 
		deprecated: 'It is a bad name as it is not precise' 
		transformWith: '`@receiver path' -> '`@receiver semanticPath'.
		
	^ self semanticPath
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

{ #category : 'accessing - method' }
CXCursor >> resultType [

	^ self ffiCall: #(CXType clang_getCursorResultType(CXCursor self))
]

{ #category : 'accessing' }
CXCursor >> semanticParent [
	| parent |
	
	parent := self clang_getCursorSemanticParent.
	^ (parent clang_Cursor_isNull)
		ifTrue: [ nil ]
		ifFalse: [ parent ]
]

{ #category : 'accessing' }
CXCursor >> semanticPath [

	^ self withAllSemanticParents allButFirst 
		collect: [ :each | 
			| elementName |
			elementName := each displayName.
			each kind = CXCursor_ClassTemplate
				ifTrue: [ elementName := elementName copyUpTo: $< ].
			elementName ]
		as: Array
]

{ #category : 'accessing' }
CXCursor >> source [
	| location fileName posStart posEnd range size source |
	
	location := self location.
	fileName := location fileName.
	fileName ifEmpty: [ ^ nil ].	
	
	range := self clang_getCursorExtent.	
	posStart := range start offset.
	posEnd := range end offset.
	size := posEnd - posStart.
	size < 1 ifTrue: [
		('I can''t get the source of "{1}" in {2}' format: { self spelling. fileName }) crTrace.
		^ '' ].
	
	fileName asFileReference readStreamDo: [ :stream |
		stream position: posStart.
		source := stream next: size ].

	^ source trimmed
]

{ #category : 'accessing - tokens' }
CXCursor >> sourceTokens [
	| range |
	
	range := self clang_getCursorExtent.	
	^ self translationUnit tokensOfRange: range
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
CXCursor >> translationUnit [

	^ self ffiCall: #(CXTranslationUnit clang_Cursor_getTranslationUnit(CXCursor self))
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
CXCursor >> withAllLexicalParents [
	| parents current |
	
	parents := OrderedCollection new.
	current := self.
	[ current notNil and: [ current clang_Cursor_isNull not ] ] 
	whileTrue: [ 
		parents add: current.
		current := current lexicalParent ].
	
	^ parents reversed
]

{ #category : 'accessing' }
CXCursor >> withAllSemanticParents [
	| parents current |
	
	parents := OrderedCollection new.
	current := self.
	[ current notNil and: [ current clang_Cursor_isNull not ] ] 
	whileTrue: [ 
		parents add: current.
		current := current semanticParent ].
	
	^ parents reversed
]

{ #category : 'accessing - tokens' }
CXCursor >> wthSourceTokensDo: aBlock [
	| range |
	
	range := self clang_getCursorExtent.	
	^ self translationUnit 
		withTokensOfRange: range 
		do: aBlock
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
