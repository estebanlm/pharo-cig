Class {
	#name : 'IGTranslation',
	#superclass : 'Object',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'as yet unclassified' }
IGTranslation class >> allTranslations [

	^ self allSubclasses collect: #new
]

{ #category : 'testing' }
IGTranslation >> appliesTo: aType [
	
	self subclassResponsibility
]

{ #category : 'accessing' }
IGTranslation >> cDeclaration [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
IGTranslation >> cDeclarationOf: aType [

	^ self cDeclaration
]

{ #category : 'converting' }
IGTranslation >> cToCPP: aString [

	^ self templateCPP format: { aString }
]

{ #category : 'converting' }
IGTranslation >> cToCPP: aString from: anElement [

	^ self cToCPP: aString
]

{ #category : 'accessing' }
IGTranslation >> cppDeclaration [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
IGTranslation >> cppDeclarationOf: aType [

	^ self cppDeclaration
]

{ #category : 'converting' }
IGTranslation >> cppToC: functionString [

	^ self templateC format: { functionString }
]

{ #category : 'converting' }
IGTranslation >> cppToC: functionString from: anElement [

	^ self cppToC: functionString
]

{ #category : 'accessing' }
IGTranslation >> templateC [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
IGTranslation >> templateCPP [

	^ self subclassResponsibility
]
