"
A translation unit for C++ sources
"
Class {
	#name : 'CigCppTranslatedUnit',
	#superclass : 'CigTranslatedUnit',
	#classTraits : '{} + TraitedClass',
	#instVars : [
		'including'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'private' }
CigCppTranslatedUnit >> addIncludedElements [

	including keysAndValuesDo: [ :aFileName :aCollection |
		| unit |
		unit := CigCppLibraryGenerator translateUnitWithoutSpecial: aFileName.
		aCollection do: [ :eachCppDeclaration | | element |
			element := unit elementAtPath: (eachCppDeclaration substrings: '::').
			self insertSpecialElement: element ] ]
]

{ #category : 'private' }
CigCppTranslatedUnit >> addSpecialElements [

	self specialElements do: [ :each | 
		each traverseElementsDo: [ :anElement |
			(self elementAtPath: anElement path allButFirst) 
				ifNil: [ self insertSpecialElement: anElement ] ] ]
]

{ #category : 'private' }
CigCppTranslatedUnit >> defaultClangArguments [
	
	^ { '-E'. '-xc++' }
]

{ #category : 'generating' }
CigCppTranslatedUnit >> generateFrom: aHeader [

	super generateFrom: aHeader.	
	aHeader hasSpecialElements 
		ifTrue: [ self addSpecialElements ]
]

{ #category : 'private' }
CigCppTranslatedUnit >> insertSpecialElement: element [

	self 
		insertSpecialElement: element 
		at: element parent path allButFirst
]

{ #category : 'private' }
CigCppTranslatedUnit >> insertSpecialElement: anElement at: aPath [

	"root element"
	aPath ifEmpty: [ 
		self addElement: anElement.
		^ anElement ].

	"look for path to add element"
	(self elementAtPath: aPath) ifNotNil: [ :parent | 
		parent addElement: anElement.
		^ anElement ].
	
	"add an empty namespace and then add the element there"
	(self 
		insertSpecialElement: (CigNamespace newName: aPath last path: aPath)
		at: aPath allButLast)
		addElement: anElement.

	^ anElement
]

{ #category : 'private' }
CigCppTranslatedUnit >> specialElements [
	"a place to keep special elements with special templates (like std namespace)"
	
	^ CigSpecialElement allElements
		collect: [ :each | each parent: self; yourself ]
]
