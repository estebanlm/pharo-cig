Extension { #name : 'CigTranslatedUnit' }

{ #category : '*CIG-Tests' }
CigTranslatedUnit class >> newForTest [

	^ self new prepareForTest
]

{ #category : '*CIG-Tests' }
CigTranslatedUnit >> prepareForTest [

	elements := OrderedCollection new
]
