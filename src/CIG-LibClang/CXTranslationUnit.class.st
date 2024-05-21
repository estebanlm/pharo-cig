Class {
	#name : 'CXTranslationUnit',
	#superclass : 'CXExternalObject',
	#classTraits : 'TLibClang classTrait',
	#category : 'CIG-LibClang',
	#package : 'CIG-LibClang'
}

{ #category : 'private' }
CXTranslationUnit class >> clang_parseIndex: CIdx 
	fileName: source_filename 
	commandLineArguments: command_line_args 
	numCommandLineArguments: num_command_line_args
	unsavedFiles: unsaved_files
	numUnsavedFiles: num_unsaved_files
	options: options [
	
 	^ self ffiCall: #(CXTranslationUnit clang_parseTranslationUnit (
		CXIndex CIdx,
		char *source_filename,
		void *"const char **"command_line_args,
		int num_command_line_args,
		"struct CXUnsavedFile *"void *unsaved_files,
		uint num_unsaved_files,
		uint options 
	))
]

{ #category : 'private' }
CXTranslationUnit class >> defaultRecordPreprocessor [

	^ false
]

{ #category : 'instance creaton' }
CXTranslationUnit class >> parseIndex: CIdx fileName: source_filename [ 

	^ self 
		clang_parseIndex: CIdx 
		fileName: source_filename 
		commandLineArguments: ExternalAddress null
		numCommandLineArguments: 0
		unsavedFiles: ExternalAddress null
		numUnsavedFiles: 0
		options: 0
	
]

{ #category : 'instance creaton' }
CXTranslationUnit class >> parseIndex: CIdx fileName: source_filename arguments: aCollection [
	
	^ self 
		parseIndex: CIdx 
		fileName: source_filename 
		arguments: aCollection
		recordPreprocessor: self defaultRecordPreprocessor
]

{ #category : 'instance creaton' }
CXTranslationUnit class >> parseIndex: CIdx fileName: source_filename arguments: aCollection recordPreprocessor: aBoolean [
	| arguments |
	
	arguments := ExternalAddress arrayOfStringsFrom: aCollection.
	^ [
		self 
			clang_parseIndex: CIdx 
			fileName: source_filename 
			commandLineArguments: arguments
			numCommandLineArguments: aCollection size
			unsavedFiles: ExternalAddress null
			numUnsavedFiles: 0
			options: (aBoolean ifTrue: [ 1 ] ifFalse: [ 0 ]) ]
		ensure: [ 
			arguments freeArrayOfStrings ]
]

{ #category : 'instance creaton' }
CXTranslationUnit class >> parseIndex: CIdx unsavedFile: anUnsavedFile arguments: aCollection [
	
	^ self 
		parseIndex: CIdx 
		unsavedFile: anUnsavedFile 
		arguments: aCollection
		recordPreprocessor: false
]

{ #category : 'instance creaton' }
CXTranslationUnit class >> parseIndex: CIdx unsavedFile: anUnsavedFile arguments: aCollection recordPreprocessor: aBoolean [
	| arguments |
	
	arguments := ExternalAddress arrayOfStringsFrom: aCollection.
	^ [
		self 
			clang_parseIndex: CIdx 
			fileName: anUnsavedFile Filename utf8StringFromCString
			commandLineArguments: arguments
			numCommandLineArguments: aCollection size
			unsavedFiles: anUnsavedFile
			numUnsavedFiles: 1
			options: (aBoolean ifTrue: [ 1 ] ifFalse: [ 0 ]) ]
		ensure: [ 
			arguments freeArrayOfStrings ]
]

{ #category : 'private' }
CXTranslationUnit >> clang_disposeTokens: tokens numTokens: numTokens [

	^ self ffiCall: #(void clang_disposeTokens(
		CXTranslationUnit self,
		"CXToken *"void *tokens,
		uint numTokens))
]

{ #category : 'private' }
CXTranslationUnit >> clang_getDiagnostic: index [

	^ self ffiCall: #(CXDiagnostic clang_getDiagnostic(self, uint index))
]

{ #category : 'private' }
CXTranslationUnit >> clang_getNumDiagnostics [

	^ self ffiCall: #(uint clang_getNumDiagnostics(self)) 	
]

{ #category : 'private' }
CXTranslationUnit >> clang_getTokenSpelling: token [

	self ffiCall: #(CXString clang_getTokenSpelling(
		CXTranslationUnit self,
		CXToken token))
]

{ #category : 'accessing - cursor' }
CXTranslationUnit >> cursor [

	^ self ffiCall: #(CXCursor clang_getTranslationUnitCursor(self))
]

{ #category : 'accessing' }
CXTranslationUnit >> diagnostics [
	| num |

	num := self clang_getNumDiagnostics.
	^ Array streamContents: [ :stream |
		 0 to: num - 1 do: [ :i | 
			stream nextPut: (self clang_getDiagnostic: i) spelling.
			 ] ]
]

{ #category : 'accessing' }
CXTranslationUnit >> dispose [

	self ffiCall: #(void clang_disposeTranslationUnit(self))
]

{ #category : 'accessing - tokens' }
CXTranslationUnit >> disposeTokens: aCollection [
	| array |
	
	aCollection isEmptyOrNil ifTrue: [ ^ self ].
	
	array := FFITypeArray newType: #'void*' size: aCollection size.
	aCollection withIndexDo: [ :each :index |
		array at: index put: each getHandle ].
	
	self clang_disposeTokens: array getHandle numTokens: aCollection size
]

{ #category : 'accessing - tokens' }
CXTranslationUnit >> tokenSpelling: token [
	| string |
	
	string := self clang_getTokenSpelling: token.
	^ [ string cString ]
		ensure: [ string dispose ]
]

{ #category : 'private' }
CXTranslationUnit >> tokenize: range tokens: tokens numTokens: numTokens [

	^ self ffiCall: #(void clang_tokenize (
		CXTranslationUnit self,
		CXSourceRange range,
		"CXToken **"void **tokens,
		"unsigned *"void *numTokens))
]

{ #category : 'accessing - tokens' }
CXTranslationUnit >> tokensOfRange: range [
	| tokensBuffer numTokensBuffer count |
	
	tokensBuffer := ExternalAddress new.
	numTokensBuffer := FFIUInt32 newBuffer.

	self tokenize: range tokens: tokensBuffer numTokens: numTokensBuffer.
	count := numTokensBuffer unsignedLongAt: 1.
	count = 0 ifTrue: [ ^ #() ].

	^ Array streamContents: [ :stream |
		0 to: (count - 1) do: [ :index |
			stream nextPut: (CXToken fromHandle: (tokensBuffer pointerAtOffset: index * FFIExternalType pointerSize)) ] ]
]

{ #category : 'accessing - tokens' }
CXTranslationUnit >> withTokensOfRange: range do: aBlock [
	| tokens |
	
	tokens := self tokensOfRange: range.
	[ aBlock value: tokens ]
	ensure: [ 
		self disposeTokens: tokens ]
]
