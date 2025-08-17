Class {
	#name : 'CigMacroDefinition',
	#superclass : 'CigElement',
	#instVars : [
		'isBuiltin',
		'isFunctionLike',
		'source',
		'isPrintable'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigMacroDefinition class >> kind [
	
	^ CXCursor_MacroDefinition
]

{ #category : 'visiting' }
CigMacroDefinition >> accept: aVisitor [
	aVisitor visitMacroDefinition: self
]

{ #category : 'visiting' }
CigMacroDefinition >> acceptNameGenerator: aVisitor [
	self halt. "This is not implemented yet. It should be something like: 
	self source 
		ifNotNil: [ :aString | self cToPharo: aString substrings allButFirst ]"
	^ aVisitor visitMacroDefinition: self
]

{ #category : 'initialization' }
CigMacroDefinition >> fromCursor: aCursor [

	super fromCursor: aCursor.
	name ifNil: [ name := aCursor displayName ].
	isBuiltin := aCursor isMacroBuiltin.
	isFunctionLike := aCursor isMacroFunctionLike.

	"fast exit to not calculate the tokens of everything"
	isFunctionLike ifTrue: [
		isPrintable := false.
		^ self ].

	aCursor withSourceTokensDo: [ :tokens :numTokens |
		isPrintable := numTokens > 1 and: [ tokens second isIdentifier not ] ]
]

{ #category : 'testing' }
CigMacroDefinition >> isFunctionLike [

	^ isFunctionLike
]

{ #category : 'testing' }
CigMacroDefinition >> isMacroDefinition [

	^ true
]

{ #category : 'testing' }
CigMacroDefinition >> isPrintable [

	^ isPrintable
]

{ #category : 'accessing' }
CigMacroDefinition >> source [

	^ source
]
