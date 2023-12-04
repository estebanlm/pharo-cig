Class {
	#name : 'IGTranslationMap',
	#superclass : 'Object',
	#instVars : [
		'translationTable'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'instance creation' }
IGTranslationMap class >> new [

	self error: 'Use #uniqueInstance'
]

{ #category : 'initialization' }
IGTranslationMap class >> reset [
	<script>

	uniqueInstance := nil
]

{ #category : 'instance creation' }
IGTranslationMap class >> uniqueInstance [

	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ]
]

{ #category : 'accessing' }
IGTranslationMap >> atType: aType ifPresent: aBlock ifAbsent: absentBlock [

	^ translationTable 
		detect: [ :each | each appliesTo: aType ]
		ifFound: [ :aTranslation | aBlock value: aTranslation ]
		ifNone: [ absentBlock value ]
]

{ #category : 'initialization' }
IGTranslationMap >> initialize [

	super initialize.
	translationTable := self translationDefinitions
]

{ #category : 'initialization' }
IGTranslationMap >> translationDefinitions [
	"name, cDeclaration, cppDeclaration. fromCPP, toCPP"

	^ IGTranslation allTranslations
]
