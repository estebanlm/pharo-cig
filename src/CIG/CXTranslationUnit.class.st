Class {
	#name : 'CXTranslationUnit',
	#superclass : 'CXExternalObject',
	#classTraits : 'TLibClang classTrait',
	#category : 'CIG-LibClang',
	#package : 'CIG',
	#tag : 'LibClang'
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
		uint  	num_unsaved_files,
		uint  	options 
	))
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
			options: 0 ]
		ensure: [ 
			arguments freeArrayOfStrings ]
]

{ #category : 'accessing - cursor' }
CXTranslationUnit >> cursor [

	^ self ffiCall: #(CXCursor clang_getTranslationUnitCursor(self))
]

{ #category : 'accessing' }
CXTranslationUnit >> dispose [

	self ffiCall: #(void clang_disposeTranslationUnit(self))
]
