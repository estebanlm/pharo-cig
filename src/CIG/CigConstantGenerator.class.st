"
Define which headers to include to generate macros and rules to match them.
Users can implement their own.
"
Class {
	#name : 'CigConstantGenerator',
	#superclass : 'Object',
	#instVars : [
		'headers',
		'excludeMacros'
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

{ #category : 'accessing' }
CigConstantGenerator >> excludeMacro: aString [

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

{ #category : 'initialization' }
CigConstantGenerator >> initialize [

	super initialize.
	excludeMacros := #()
]

{ #category : 'testing' }
CigConstantGenerator >> isPrintable: aMacroDefinition [

	^ (excludeMacros includes: aMacroDefinition name) not
]
