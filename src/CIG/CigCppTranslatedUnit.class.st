"
A translation unit for C++ sources
"
Class {
	#name : 'CigCppTranslatedUnit',
	#superclass : 'CigTranslatedUnit',
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
			self insertElement: element ] ]
]

{ #category : 'private' }
CigCppTranslatedUnit >> addSpecialElements [

	self specialElements do: [ :each | 
		each traverseElementsDo: [ :anElement |
			(self elementAtPath: anElement path allButFirst) 
				ifNil: [ self insertElement: anElement ] ] ]
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
CigCppTranslatedUnit >> specialElements [
	"a place to keep special elements with special templates (like std namespace)"
	
	^ CigSpecialElement allElements
		collect: [ :each | each parent: self; yourself ]
]
