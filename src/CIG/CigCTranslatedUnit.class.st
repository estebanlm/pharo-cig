"
A translation unit for C sources
"
Class {
	#name : 'CigCTranslatedUnit',
	#superclass : 'CigTranslatedUnit',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'private' }
CigCTranslatedUnit >> defaultClangArguments [
	
	^ { '-E' }
]
