Class {
	#name : 'CigPharoGenerator',
	#superclass : 'Object',
	#instVars : [
		'file',
		'unit'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'instance creation' }
CigPharoGenerator class >> newFile: aFile [

	^ self new file: aFile
]

{ #category : 'instance creation' }
CigPharoGenerator class >> newFile: aFile unit: aUnit [

	^ self new 
		file: aFile;
		unit: aUnit;
		yourself
]

{ #category : 'private' }
CigPharoGenerator >> baseObjectClass [

	^ self class environment classNamed: self baseObjectClassName
]

{ #category : 'private' }
CigPharoGenerator >> baseObjectClassName [

	^ String streamContents: [ :stream |
		stream 
			<< self prefix capitalized
			<< 'BaseObject' ]
]

{ #category : 'private' }
CigPharoGenerator >> defaultNamespaceName [

	^ 'Base'
]

{ #category : 'accessing' }
CigPharoGenerator >> file [

	^ file
]

{ #category : 'accessing' }
CigPharoGenerator >> file: aLibraryGenerator [

	file := aLibraryGenerator
]

{ #category : 'generating' }
CigPharoGenerator >> generate [

	self subclassResponsibility
]

{ #category : 'private' }
CigPharoGenerator >> libraryClass [

	^ self class environment classNamed: self libraryName
]

{ #category : 'private' }
CigPharoGenerator >> libraryName [

	^ 'Lib', self file bindingsName capitalized
]

{ #category : 'private' }
CigPharoGenerator >> libraryTrait [

	^ self class environment classNamed: self libraryTraitName
]

{ #category : 'private' }
CigPharoGenerator >> libraryTraitName [

	^ 'LibT', self file bindingsName capitalized
]

{ #category : 'private' }
CigPharoGenerator >> libraryTypedefClass [

	^ self class environment classNamed: self libraryTypedefName
]

{ #category : 'private' }
CigPharoGenerator >> libraryTypedefName [
		
	^ String streamContents: [ :stream |
		stream 
			<< self prefix capitalized
			<< self file bindingsName capitalized 
			<< 'Typedef' ]
]

{ #category : 'private' }
CigPharoGenerator >> packageName [

	^ self libraryName
]

{ #category : 'private' }
CigPharoGenerator >> prefix [

	^ self unit prefix
]

{ #category : 'accessing' }
CigPharoGenerator >> unit [

	^ unit
]

{ #category : 'accessing' }
CigPharoGenerator >> unit: aUnit [

	unit := aUnit
]
