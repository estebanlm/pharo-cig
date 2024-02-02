Class {
	#name : 'CigImportResolver',
	#superclass : 'Object',
	#instVars : [
		'arguments',
		'import'
	],
	#pools : [
		'CXCursorKind'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'resolving' }
CigImportResolver class >> sanitize: aString [
	| sanitizedFileName localName |

	sanitizedFileName	:= aString asFileReference canonicalize fullName.
	localName := FileLocator workingDirectory fullName.
	^ (sanitizedFileName beginsWith: localName)
		ifTrue: [ sanitizedFileName allButFirst: localName size ]
		ifFalse: [ sanitizedFileName ]
]

{ #category : 'accessing' }
CigImportResolver >> arguments [

	^ arguments
]

{ #category : 'accessing' }
CigImportResolver >> arguments: anArray [

	arguments := anArray
]

{ #category : 'accessing' }
CigImportResolver >> import [

	^ import
]

{ #category : 'accessing' }
CigImportResolver >> import: aString [

	import := aString
]

{ #category : 'resolving' }
CigImportResolver >> resolve [
	| file index unit result | 
	
	file := CXUnsavedFile 
		newFileName: 'get_headers.c'
		contents: (('#include <{1}>
int main() \{ 
	return 0; 
}') format: { self import }).

	index := CXIndex createIndex: 0 diagnostics: 0. 
	unit := CXTranslationUnit 
		parseIndex: index 
		unsavedFile: file
		arguments: self arguments
		recordPreprocessor: true.
	 
	result := self import.
	unit cursor visitChildren: [ :current :parent :data |
		((current kind = CXCursor_InclusionDirective) and: [ current displayName = self import ]) 
			ifTrue: [
				result := current includedFileName.
				CXChildVisit break ]
			ifFalse: [
				CXChildVisit continue ] ].

	unit dispose.
	index dispose.
	file dispose.

	^ self sanitize: result
]

{ #category : 'resolving' }
CigImportResolver >> sanitize: aString [

	^ self class sanitize: aString
]
