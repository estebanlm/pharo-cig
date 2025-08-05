Class {
	#name : 'CigCommandExecutor',
	#superclass : 'Object',
	#instVars : [
		'home',
		'command'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'instance creation' }
CigCommandExecutor class >> execute: aString [

	^ (self newCommand: aString) execute
]

{ #category : 'instance creation' }
CigCommandExecutor class >> newCommand: aString [

	^ self new 
		command: aString;
		yourself
]

{ #category : 'accessing' }
CigCommandExecutor >> command [

	^ command
]

{ #category : 'accessing' }
CigCommandExecutor >> command: aString [

	command := aString
]

{ #category : 'executing' }
CigCommandExecutor >> execute [
	| result logReference |

	logger trace: command.
	
	logReference := (self home / 'command-output.txt') ensureDelete.
	result := LibC resultOfCommand: ('cd {1} && {2} 2> {3}' format: { 
		self home fullName.
		self command. 
		logReference fullName }).
	logReference exists ifTrue: [
		| logError |
		logError := logReference contents.
		logError ifNotEmpty: [
			logger error: 'Command not executed.'.
			CigCommandExecutionError new 
				command: command;
				log: logError;
				signal ] ].
			
	^ result
]

{ #category : 'accessing' }
CigCommandExecutor >> home [

	^ home ifNil: [ 
		self home: FileLocator temp / 'CIG'.
		home ]
]

{ #category : 'accessing' }
CigCommandExecutor >> home: aStringOrReference [

	home := aStringOrReference asFileReference ensureCreateDirectory
]
