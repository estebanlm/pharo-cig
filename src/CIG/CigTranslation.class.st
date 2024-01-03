Class {
	#name : 'CigTranslation',
	#superclass : 'Object',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'as yet unclassified' }
CigTranslation class >> allTranslations [

	^ self allSubclasses collect: #new
]

{ #category : 'testing' }
CigTranslation >> appliesTo: aType [
	
	self subclassResponsibility
]

{ #category : 'accessing' }
CigTranslation >> cDeclaration [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
CigTranslation >> cDeclarationOf: aType [

	^ self cDeclaration
]

{ #category : 'converting' }
CigTranslation >> cToCPP: aString [

	^ self templateCPP format: { aString }
]

{ #category : 'converting' }
CigTranslation >> cToCPP: aString from: anElement [

	^ self cToCPP: aString
]

{ #category : 'accessing' }
CigTranslation >> cppDeclaration [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
CigTranslation >> cppDeclarationOf: aType [

	^ self cppDeclaration
]

{ #category : 'converting' }
CigTranslation >> cppToC: functionString [

	^ self templateC format: { functionString }
]

{ #category : 'converting' }
CigTranslation >> cppToC: functionString from: anElement [

	^ self cppToC: functionString
]

{ #category : 'accessing' }
CigTranslation >> templateC [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
CigTranslation >> templateCPP [

	^ self subclassResponsibility
]
