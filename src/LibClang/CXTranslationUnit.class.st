Class {
	#name : 'CXTranslationUnit',
	#superclass : 'CXExternalObject',
	#classTraits : 'TLibClang classTrait',
	#category : 'LibClang',
	#package : 'LibClang'
}

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
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

{ #category : 'accessing - cursor' }
CXTranslationUnit >> cursor [

	^ self ffiCall: #(CXCursor clang_getTranslationUnitCursor(self))
]
