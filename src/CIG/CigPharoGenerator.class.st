Class {
	#name : 'CigPharoGenerator',
	#superclass : 'Object',
	#traits : 'CigTLoggeable',
	#classTraits : 'CigTLoggeable classTrait',
	#instVars : [
		'file',
		'unit',
		'element'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'instance creation' }
CigPharoGenerator class >> newFile: aFile [

	^ self new file: aFile
]

{ #category : 'instance creation' }
CigPharoGenerator class >> newFile: aFile element: anElement [

	^ self new 
		file: aFile;
		unit: anElement root;
		element: anElement;
		yourself
]

{ #category : 'instance creation' }
CigPharoGenerator class >> newFile: aFile unit: aUnit [

	^ self new 
		file: aFile;
		unit: aUnit;
		yourself
]

{ #category : 'private' }
CigPharoGenerator >> baseEnumClass [

	^ self class environment classNamed: self baseEnumClassName
]

{ #category : 'private' }
CigPharoGenerator >> baseEnumClassName [

	^ String streamContents: [ :stream |
		stream 
			<< self prefix capitalized
			<< 'Enumeration' ]
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
CigPharoGenerator >> baseStructureClass [

	^ self class environment classNamed: self baseStructureClassName
]

{ #category : 'private' }
CigPharoGenerator >> baseStructureClassName [

	^ String streamContents: [ :stream |
		stream 
			<< self prefix capitalized
			<< 'Structure' ]
]

{ #category : 'private' }
CigPharoGenerator >> baseUnionClass [

	^ self class environment classNamed: self baseUnionClassName
]

{ #category : 'private' }
CigPharoGenerator >> baseUnionClassName [

	^ String streamContents: [ :stream |
		stream 
			<< self prefix capitalized
			<< 'Union' ]
]

{ #category : 'private' }
CigPharoGenerator >> defaultNamespaceName [

	^ 'Base'
]

{ #category : 'accessing' }
CigPharoGenerator >> element [

	^ element
]

{ #category : 'accessing' }
CigPharoGenerator >> element: anElement [

	element := anElement
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

{ #category : 'generating' }
CigPharoGenerator >> generateOn: aVisitor [

	self generate
]

{ #category : 'private' }
CigPharoGenerator >> libraryClass [

	^ self class environment classNamed: self libraryName
]

{ #category : 'private' }
CigPharoGenerator >> libraryName [

	^ 'Lib', self file libraryName capitalized
]

{ #category : 'private' }
CigPharoGenerator >> libraryTrait [

	^ self class environment classNamed: self libraryTraitName
]

{ #category : 'private' }
CigPharoGenerator >> libraryTraitName [

	^ 'LibT', self file libraryName capitalized
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
			<< self file libraryName capitalized 
			<< 'Typedef' ]
]

{ #category : 'private' }
CigPharoGenerator >> namespaceName [

	^ (self element depth > 1 and: [ self element parent isNamespace ]) 
		ifTrue: [ self element parent basename capitalized ]
		ifFalse: [ self defaultNamespaceName ]
]

{ #category : 'private' }
CigPharoGenerator >> packageName [

	^ self libraryName
]

{ #category : 'private' }
CigPharoGenerator >> prefix [

	^ self unit prefix
]

{ #category : 'private' }
CigPharoGenerator >> sharedPoolNames [

	^ Array streamContents: [ :stream |
		((self unit namespaces collect: #typedef as: Set)
			sorted: #name ascending)
			do: [ :each | stream nextPut: each name ].
		stream nextPut: self libraryTypedefName asSymbol ]
]

{ #category : 'accessing' }
CigPharoGenerator >> unit [

	^ unit
]

{ #category : 'accessing' }
CigPharoGenerator >> unit: aUnit [

	unit := aUnit
]
