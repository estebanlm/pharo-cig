Class {
	#name : 'CigMacroDefinition',
	#superclass : 'CigElement',
	#instVars : [
		'isBuiltin',
		'isFunctionLike',
		'source'
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

]

{ #category : 'visiting' }
CigMacroDefinition >> acceptNameGenerator: aVisitor [
	self halt. "This is not implemented yet. It should be something like: 
	self source 
		ifNotNil: [ :aString | self cToPharo: aString substrings allButFirst ]"
	^ aVisitor visitMacro: self
]

{ #category : 'initialization' }
CigMacroDefinition >> fromCursor: aCursor [

	super fromCursor: aCursor.
	isBuiltin := aCursor isMacroBuiltin.
	isFunctionLike := aCursor isMacroFunctionLike.

	self flag: #TODO. "I think this is better done with tokens (see sourceTokens and around). 
	But for some reason it is crashing. Since I can achieve more or less the same and faster 
	tokenising myself the source, I'll go that way for now."	
	source := aCursor source 
		ifNotNil: [ :aString | ' ' join: aString substrings allButFirst ]
]

{ #category : 'testing' }
CigMacroDefinition >> isMacroDefinition [

	^ true
]

{ #category : 'accessing' }
CigMacroDefinition >> source [

	^ source
]
