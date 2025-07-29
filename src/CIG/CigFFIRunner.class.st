"
Indicates the type of runner that the library will use (by default, same thread)
"
Class {
	#name : 'CigFFIRunner',
	#superclass : 'Object',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigFFIRunner >> phTemplate [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
CigFFIRunner >> variablesAddedToFFILibrary [

	^ #()
]
