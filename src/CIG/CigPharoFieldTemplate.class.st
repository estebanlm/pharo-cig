"
Template for `CigField`, to properly generate its declarations.
"
Class {
	#name : 'CigPharoFieldTemplate',
	#superclass : 'CigPharoTemplate',
	#category : 'CIG-Pharo-Template',
	#package : 'CIG',
	#tag : 'Pharo-Template'
}

{ #category : 'as yet unclassified' }
CigPharoFieldTemplate >> generateFieldDesc [

	^ String streamContents: [ :stream |
		stream << self element cTemplate generateFFIType << ' ' << self element name ]
]
