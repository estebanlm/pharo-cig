"
A template to generate function calls which return value needs to be passed as parameter in a buffer (since we cannot return it as usual).
"
Class {
	#name : 'CigPharoFunctionReturnAsParameterTemplate',
	#superclass : 'CigPharoFunctionTemplate',
	#category : 'CIG-Pharo-Template',
	#package : 'CIG',
	#tag : 'Pharo-Template'
}

{ #category : 'private' }
CigPharoFunctionReturnAsParameterTemplate class >> handlesElement: anElement [

	^ anElement exposesReturnValueAsParameter
]

{ #category : 'generating' }
CigPharoFunctionReturnAsParameterTemplate >> generateHeader [
	
	^ (String streamContents: [ :stream | 
			stream  << self element spelling uncapitalized.
			self 
				buildParameters: self parameters 
				on: stream ])
		trimmed
]

{ #category : 'private' }
CigPharoFunctionReturnAsParameterTemplate >> parameterSizeForNameThreshold [

	^ 2
]

{ #category : 'private' }
CigPharoFunctionReturnAsParameterTemplate >> parameters [

	^ super parameters copyWith: (CigParameter newName: 'result')
]
