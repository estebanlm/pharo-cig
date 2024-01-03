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

{ #category : 'private' }
CigPharoFunctionReturnAsParameterTemplate >> parameterSizeForNameThreashold [

	^ 2
]

{ #category : 'private' }
CigPharoFunctionReturnAsParameterTemplate >> parameters [

	^ super parameters copyWith: (CigParameter newName: 'result')
]
