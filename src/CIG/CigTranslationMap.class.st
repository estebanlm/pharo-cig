Class {
	#name : 'CigTranslationMap',
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
CigTranslationMap class >> new [

	self error: 'Use #uniqueInstance'
]

{ #category : 'initialization' }
CigTranslationMap class >> reset [
	<script>

	uniqueInstance := nil
]

{ #category : 'instance creation' }
CigTranslationMap class >> uniqueInstance [

	^ uniqueInstance ifNil: [ uniqueInstance := self basicNew initialize ]
]

{ #category : 'accessing' }
CigTranslationMap >> atType: aType ifPresent: aBlock ifAbsent: absentBlock [

	^ translationTable 
		detect: [ :each | each appliesTo: aType ]
		ifFound: [ :aTranslation | aBlock value: aTranslation ]
		ifNone: [ absentBlock value ]
]

{ #category : 'initialization' }
CigTranslationMap >> initialize [

	super initialize.
	translationTable := self translationDefinitions
]

{ #category : 'initialization' }
CigTranslationMap >> translationDefinitions [
	"name, cDeclaration, cppDeclaration. fromCPP, toCPP"

	^ CigTranslation allTranslations
]
