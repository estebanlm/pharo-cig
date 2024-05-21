Class {
	#name : 'CigPharoTypedefFunctionReferenceTemplate',
	#superclass : 'CigPharoTypedefTemplate',
	#category : 'CIG-Pharo-Template',
	#package : 'CIG',
	#tag : 'Pharo-Template'
}

{ #category : 'private' }
CigPharoTypedefFunctionReferenceTemplate class >> handlesElement: anElement [

	^ anElement definesFunctionPointer not 
		and: [ anElement definesFunction ]
]

{ #category : 'generating' }
CigPharoTypedefFunctionReferenceTemplate >> generate [

	^ '#void'
]
