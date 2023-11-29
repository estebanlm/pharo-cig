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

{ #category : 'as yet unclassified' }
IGTranslationMap >> cDeclarationOf: aString ifFound: aBlock [

	translationTable 
		at: aString 
		ifPresent: [ :aTranslation | aBlock value: aTranslation cDeclaration ]
]

{ #category : 'as yet unclassified' }
IGTranslationMap >> cppDeclarationOf: aString ifFound: aBlock [

	translationTable 
		at: aString 
		ifPresent: [ :aTranslation | aBlock value: aTranslation cppDeclaration ]
]

{ #category : 'initialization' }
IGTranslationMap >> initialize [

	super initialize.
	translationTable := self translationDefinitions 
		collect: [ :each | 
			(each first) -> (IGTranslation fromArray: each) ]
		as: Dictionary
]

{ #category : 'initialization' }
IGTranslationMap >> translationDefinitions [
	"name, cDeclaration, cppDeclaration. fromCPP, toCPP"

	^ #(
		('std::string' 'const char *' 'const char *' '{1}.c_str()' nil)
	)
]
