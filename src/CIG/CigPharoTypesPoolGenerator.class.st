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
					<< assoc value ]
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
