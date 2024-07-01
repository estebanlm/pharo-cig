"
Executes the makefile created while generating the C bindings of a C++ library.
"
Class {
	#name : 'CigMakefile',
	#superclass : 'OSPlatformVisitor',
	#traits : 'CigTLoggeable',
	#classTraits : 'CigTLoggeable classTrait',
	#instVars : [
		'file'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'execution' }
CigMakefile class >> executeFor: aString [

	^ self new executeFor: aString
]

{ #category : 'execution' }
CigMakefile >> executeFor: aFile [

	file := aFile.
	self logInfo: ('Executing Makefile for {1}' format: { self file bindingsName }).
	^ self visit
]

{ #category : 'accessing' }
CigMakefile >> file [

	^ file
]

{ #category : 'visiting' }
CigMakefile >> find: aFileName in: aPathCollection [
	
	^ aPathCollection 
		detect: [ :each | (each asFileReference / aFileName) exists ]
		ifFound: [ :each | (each asFileReference / aFileName) fullName ]
		ifNone: [ self error: ('{1} not fond' format: { aFileName }) ]
]

{ #category : 'visiting' }
CigMakefile >> visitUnix: aPlatform [
	| makefile process |
	
	makefile := self 
		find: 'make'
		in: ((aPlatform environment at: 'PATH') substrings: ':').
	
	process := GIOPipedProcess 
		spawn: makefile
		arguments: #() 
		workingDirectory: file cFileReference parent fullName
		flags: GSpawnFlags G_SPAWN_DEFAULT.
		
	self logDebug: [ process outChannel readAllLines asStringWithCr].
	(process errChannel readAllLines 
		reject: [ :each | each trimmed isEmpty  ])
		ifNotEmpty: [ :errorLines |
			self error: errorLines asStringWithCr ]
]
