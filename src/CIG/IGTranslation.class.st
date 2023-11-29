Class {
	#name : 'IGTranslation',
	#superclass : 'Object',
	#instVars : [
		'name',
		'cDeclaration',
		'cppDeclaration',
		'fromCPP',
		'toCPP'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'instance creation' }
IGTranslation class >> fromArray: anArray [

	^ self new fromArray: anArray
]

{ #category : 'accessing' }
IGTranslation >> cDeclaration [

	^ cDeclaration
]

{ #category : 'accessing' }
IGTranslation >> cDeclaration: aString [

	cDeclaration := aString
]

{ #category : 'accessing' }
IGTranslation >> cppDeclaration [

	^ cppDeclaration
]

{ #category : 'accessing' }
IGTranslation >> cppDeclaration: aString [

	cppDeclaration := aString
]

{ #category : 'initialization' }
IGTranslation >> fromArray: anArray [

	name := anArray first. 
	cDeclaration := anArray second.
	cppDeclaration := anArray third.
	fromCPP := anArray fourth.
	toCPP := anArray fifth 
]

{ #category : 'accessing' }
IGTranslation >> fromCPP [

	^ fromCPP
]

{ #category : 'accessing' }
IGTranslation >> fromCPP: aString [

	fromCPP := aString
]

{ #category : 'accessing' }
IGTranslation >> name [

	^ name
]

{ #category : 'accessing' }
IGTranslation >> name: aString [

	name := aString
]

{ #category : 'accessing' }
IGTranslation >> toCPP [

	^ toCPP
]

{ #category : 'accessing' }
IGTranslation >> toCPP: aString [

	toCPP := aString
]
