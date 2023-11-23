Class {
	#name : 'IGClassVisitor',
	#superclass : 'IGVisitor',
	#instVars : [
		'generator',
		'class',
		'functionPrefix'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'private' }
IGClassVisitor >> functionNameOf: aFunction [

	^ (String streamContents: [ :stream | 
			stream 
				<< functionPrefix
				<< aFunction spelling.
			aFunction parameters do: [ :each | 
				stream 
					<< each name 
					<< ': ' 
					<< each name 
					<< ' ' ] ])
		trimmed
]

{ #category : 'visiting' }
IGClassVisitor >> visitAll: aCollection [


	class := FFILibrary << self file libraryClassName
		package: self file libraryClassName;
		install. 
	
	class 
		compile: ('unix64LibraryName

	^ FFIUnix64LibraryFinder findLibrary: ''{1}''
' format: { (self file cFileReference withExtension: 'so') basename })
		classified: 'accessing - platform'.
	
	functionPrefix := ''.
	super visitAll: aCollection
]

{ #category : 'visiting' }
IGClassVisitor >> visitEnum: anEnum [
	| enum template |

	enum := FFIEnumeration << anEnum name
		package: self file libraryClassName;
		install. 

	template := String streamContents: [ :stream |
		stream << 'enumDecl

	^ #(		
'.
		anEnum elements 
			do: [ :each | stream << '    ' << each name << ' ' << each value asString ]
			separatedBy: [ stream cr ].
		stream <<  ' )'].
	
	enum class
		compile: template
		classified: 'enum declaration'.
		
	enum 
		initializeEnumeration;
		rebuildEnumAccessors
]

{ #category : 'visiting' }
IGClassVisitor >> visitFunction: aFunction [
	| template |
	
	template := '{1}
	
	self ffiCall: #({2})
' format: { 
	self functionNameOf: aFunction.
	aFunction asFunctionDeclarationWithPrefix: functionPrefix 
	}.
	
	class compile: template classified: 'functions'
]

{ #category : 'visiting' }
IGClassVisitor >> visitNamespace: aNamespace [

	functionPrefix := aNamespace name.
	super visitNamespace: aNamespace
]
