Class {
	#name : 'CigPharoTypedefCallbackTemplate',
	#superclass : 'CigPharoTypedefTemplate',
	#category : 'CIG-Pharo-Template',
	#package : 'CIG',
	#tag : 'Pharo-Template'
}

{ #category : 'private' }
CigPharoTypedefCallbackTemplate class >> handlesElement: anElement [

	^ anElement definesFunction
]

{ #category : 'generating' }
CigPharoTypedefCallbackTemplate >> generate [

	^ 'FFICallback'
]