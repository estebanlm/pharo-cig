Class {
	#name : 'CigCallbackTranslation',
	#superclass : 'CigTranslation',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'testing' }
CigCallbackTranslation >> appliesTo: aType [
	
	^ aType definesFunction
]

{ #category : 'accessing' }
CigCallbackTranslation >> cDeclaration [

	^ 'void*'
]

{ #category : 'converting' }
CigCallbackTranslation >> cToCPP: aString from: anElement [

	^ '({1}){2}' format: { anElement typeName. aString }
]
