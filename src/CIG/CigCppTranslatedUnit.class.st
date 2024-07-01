"
A translation unit for C++ sources
"
Class {
	#name : 'CigCppTranslatedUnit',
	#superclass : 'CigTranslatedUnit',
	#instVars : [
		'classSpecializations'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'private' }
CigCppTranslatedUnit >> addSpecialElements [

	self specialElements do: [ :each | 
		each traverseElementsDo: [ :anElement |
			(self elementAtPath: anElement path allButFirst) 
				ifNil: [ self insertElement: anElement ] ] ]
]

{ #category : 'accessing' }
CigCppTranslatedUnit >> classSpecializations [

	^ classSpecializations ifNil: [ #() ]
]

{ #category : 'private' }
CigCppTranslatedUnit >> defaultClangArguments [
	
	^ { '-E'. '-xc++'. '-isystem /usr/include/c++/14.1.1' }
]

{ #category : 'accessing' }
CigCppTranslatedUnit >> elementAtPath: aPath [

	(super elementAtPath: aPath) 
		ifNotNil: [ :anElement | ^ anElement ].
	
	self namespaces do: [ :each |
		(self elementAtPath: aPath inNamespace: each)
			ifNotNil: [ :anElement | ^ anElement ] ].
		
	^ nil
	
]

{ #category : 'accessing' }
CigCppTranslatedUnit >> elementAtPath: aPath inNamespace: aNamespace [
	| elementName |
	
	elementName := String streamContents: [ :stream |
		stream << aNamespace cppPrefix << '_'.
		aPath asStringOn: stream delimiter: '_' ].
	
	^ aNamespace typedef classPool
		at: elementName asSymbol
		ifPresent: [ :anObject | 
			CigImportedNamespaceElement new
				path: aPath;
				cType: elementName;
				reference: anObject;
				yourself ]
		ifAbsent: [ nil ]
]

{ #category : 'generating' }
CigCppTranslatedUnit >> generateFrom: aHeader [

	classSpecializations := aHeader cClassSpecializations.
	super generateFrom: aHeader.	
	aHeader hasSpecialElements 
		ifTrue: [ self addSpecialElements ]
]

{ #category : 'testing' }
CigCppTranslatedUnit >> isCPP [

	^ true
]

{ #category : 'private' }
CigCppTranslatedUnit >> specialElements [
	"a place to keep special elements with special templates (like std namespace)"
	
	^ CigSpecialElement allElements
		collect: [ :each | each parent: self; yourself ]
]
