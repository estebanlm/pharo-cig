"
This error happen when user tries to execute a command and for some reason the system is unable to complete it.
It contains a `log` with the stderr output of the execution to provide some more information.
"
Class {
	#name : 'CigCommandExecutionError',
	#superclass : 'Error',
	#instVars : [
		'command',
		'log'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'accessing' }
CigCommandExecutionError >> command: aString [

	command := aString
]

{ #category : 'accessing' }
CigCommandExecutionError >> log: aString [

	log := aString
]

{ #category : 'accessing' }
CigCommandExecutionError >> messageText [

	^ 'Unable to execute {1}.' format: { command } 
]
