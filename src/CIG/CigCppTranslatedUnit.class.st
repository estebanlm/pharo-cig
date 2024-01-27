"
A translation unit for C++ sources
"
Class {
	#name : 'CigCppTranslatedUnit',
	#superclass : 'CigTranslatedUnit',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'private' }
CigCppTranslatedUnit >> defaultClangArguments [
	
	^ { '-E'. '-xc++' }
]

{ #category : 'generating' }
CigCppTranslatedUnit >> generateFrom: aHeader [

	super generateFrom: aHeader.	
	"add special elements at the end"
	elements addAll: self specialElements
]

{ #category : 'private' }
CigCppTranslatedUnit >> specialElements [
	"a place to keep special elements with special templates (like std namespace)"
	
	^ CigSpecialElement allElements
		collect: [ :each | each parent: self; yourself ]
]
