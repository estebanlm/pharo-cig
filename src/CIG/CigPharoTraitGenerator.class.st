Class {
	#name : 'CigPharoTraitGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedTrait'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'as yet unclassified' }
CigPharoTraitGenerator >> addLibraryAccessor [

	generatedTrait 
		compile: self libraryAccessorTemplate
		classified: 'library path'
]

{ #category : 'as yet unclassified' }
CigPharoTraitGenerator >> addLibraryClassAccessor [

	generatedTrait class
		compile: self libraryAccessorTemplate
		classified: 'library path'
]

{ #category : 'as yet unclassified' }
CigPharoTraitGenerator >> addTrait [
	| ffiTraitName ffiLibraryName |

	ffiLibraryName := self libraryName.
	ffiTraitName := self libraryTraitName.
	generatedTrait := Trait << ffiTraitName asSymbol
		tag: 'Library';
		package: self packageName;
		install
]

{ #category : 'generating' }
CigPharoTraitGenerator >> generate [

	self addTrait.
	self addLibraryAccessor.
	self addLibraryClassAccessor
]

{ #category : 'as yet unclassified' }
CigPharoTraitGenerator >> libraryAccessorTemplate [
		
	^ String streamContents: [ :stream |
		stream << 'ffiLibraryName'; cr.
		stream cr; tab.
		stream << '^ ' << self libraryName ]
]
