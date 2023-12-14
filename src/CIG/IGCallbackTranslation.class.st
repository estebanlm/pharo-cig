Class {
	#name : 'IGCallbackTranslation',
	#superclass : 'IGTranslation',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'testing' }
IGCallbackTranslation >> appliesTo: aType [
	
	^ aType definesFunction
]

{ #category : 'accessing' }
IGCallbackTranslation >> cDeclaration [

	^ 'void*'
]

{ #category : 'converting' }
IGCallbackTranslation >> cToCPP: aString from: anElement [

	^ '({1}){2}' format: { anElement typeName. aString }
]
