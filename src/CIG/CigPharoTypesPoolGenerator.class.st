Class {
	#name : 'CigPharoTypesPoolGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private' }
CigPharoTypesPoolGenerator >> addClassInitializationMethodTypes: aDictionary [

	generatedClass class 
		compile: (self classInitializationTemplate: aDictionary)
		classified: 'class initialization'.
		
	generatedClass initialize
]

{ #category : 'private' }
CigPharoTypesPoolGenerator >> addClassWithTypes: aDictionary [
	| typesName |

	typesName := self libraryTypedefName.
	generatedClass := SharedPool << typesName asSymbol
		sharedVariables: (self collectSharedVariables: aDictionary); 
		tag: 'Library';
		package: self packageName;
		install
]

{ #category : 'private' }
CigPharoTypesPoolGenerator >> classInitializationTemplate: aDictionary [

	^ String streamContents: [ :stream |
		stream << 'initialize'; cr; cr.
		self cppTypes, aDictionary associations 
			do: [ :assoc | 
				stream tab.
				stream 
					<<  assoc key 
					<< ' := ' 
					<< (self valueFor: assoc value in: aDictionary) ]
			separatedBy: [ stream << '.'; cr ] ]
]

{ #category : 'private' }
CigPharoTypesPoolGenerator >> collectSharedVariables: aDictionary [
		
	^ (self cppKeys), (aDictionary keys) 
		collect: [ :each | each asSymbol ] 
		as: Array
]

{ #category : 'private' }
CigPharoTypesPoolGenerator >> cppKeys [
		
	^ CigCPPTypedef classPool keys
]

{ #category : 'private' }
CigPharoTypesPoolGenerator >> cppTypes [
		
	^ CigCPPTypedef classPool associations 
		collect: [ :each | each key -> ('#', (self toPrintableSymbol: each value)) ]
]

{ #category : 'generating' }
CigPharoTypesPoolGenerator >> generate [

	self addClassWithTypes: Dictionary new
]

{ #category : 'generating' }
CigPharoTypesPoolGenerator >> generateTypes: aDictionary [
	
	self addClassWithTypes: aDictionary.
	self addClassInitializationMethodTypes: aDictionary
]

{ #category : 'private' }
CigPharoTypesPoolGenerator >> toPrintableSymbol: aSymbol [

	aSymbol isAllAlphaNumerics ifFalse: [ 
		^ String streamContents: [ :stream |
			stream << '''' << aSymbol asString << '''' ] ].
	
	^ aSymbol
]

{ #category : 'private' }
CigPharoTypesPoolGenerator >> valueFor: aValue in: aDictionary [
	| parsed type parsedType value |

	logger trace: aValue.

	aValue isString ifFalse: [ ^ aValue ].

	parsed := aValue substrings: '[]'.
	parsed size < 2 ifTrue: [ ^ aValue ].
	type := parsed first.
	parsedType := 
		[ CigType resolveFFIType: type strict: true ] 
		on: CigTypeNotFound 
		do: [ :e | type ].
	value := 'FFIArray ofType: {3}{1}{3} size: {2} requestor: self' format: { 
		parsedType. 
		String streamContents: [ :stream | 
			parsed allButFirst
				do: [ :each | stream << each ]
				separatedBy: [ stream << '*' ] ].
		(aDictionary includesKey: type) ifTrue: [ '' ] ifFalse: [ $' ] }.
	
	logger trace: value.
	
	^ value
]
