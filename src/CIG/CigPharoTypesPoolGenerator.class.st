Class {
	#name : 'CigPharoTypesPoolGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedTrait',
		'generatedClass'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'private' }
CigPharoTypesPoolGenerator >> addClass [ 
	| typesName |

	typesName := self libraryTypedefName.
	generatedClass := SharedPool << typesName asSymbol
		tag: 'Library';
		package: self packageName;
		install
]

{ #category : 'generating' }
CigPharoTypesPoolGenerator >> generate [

	self addClass
]
