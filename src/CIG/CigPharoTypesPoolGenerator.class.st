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
		aDictionary associations 
			do: [ :assoc | stream <<  String tab <<  assoc key << ' := ' << assoc value ]
			separatedBy: [ stream << '.'; cr ] ]
]

{ #category : 'private' }
CigPharoTypesPoolGenerator >> collectSharedVariables: aDictionary [
		
	^ aDictionary keys 
		collect: #asSymbol 
		as: Array
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
