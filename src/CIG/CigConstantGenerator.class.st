"
Define which headers to include to generate macros and rules to match them.
Users can implement their own.
"
Class {
	#name : 'CigConstantGenerator',
	#superclass : 'Object',
	#instVars : [
		'headers',
		'excludeMacros',
		'printHex'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigConstantGenerator >> addHeader: aString [ 

	headers ifNil: [ headers := #() ].
	headers := headers copyWith: aString
]

{ #category : 'accessing - scripting' }
CigConstantGenerator >> exclude: aString [

	excludeMacros := excludeMacros copyWith: aString
]

{ #category : 'accessing' }
CigConstantGenerator >> excludeMacros: aCollection [

	excludeMacros := aCollection
]

{ #category : 'accessing' }
CigConstantGenerator >> headers [

	^ headers
]

{ #category : 'accessing' }
CigConstantGenerator >> headers: aCollection [

	headers := aCollection
]

{ #category : 'accessing - scripting' }
CigConstantGenerator >> include: aString [ 

	self addHeader: aString
]

{ #category : 'initialization' }
CigConstantGenerator >> initialize [

	super initialize.
	printHex := true.
	excludeMacros := #()
]

{ #category : 'testing' }
CigConstantGenerator >> isPrintable: aMacroDefinition [

	^ (excludeMacros includes: aMacroDefinition name) not
]

{ #category : 'accessing' }
CigConstantGenerator >> printDecimal [

	printHex := false
]

{ #category : 'accessing' }
CigConstantGenerator >> printHex [

	printHex := true
]

{ #category : 'testing' }
CigConstantGenerator >> shouldPrintNumbersAsHex [

	^ printHex
]
