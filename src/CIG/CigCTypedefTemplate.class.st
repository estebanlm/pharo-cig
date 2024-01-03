Class {
	#name : 'CigCTypedefTemplate',
	#superclass : 'CigCTemplate',
	#instVars : [
		'type'
	],
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'generating' }
CigCTypedefTemplate >> generate [

	^ 'typedef {cType} {definition};' 
	format: { 
		#cType -> self typeName.
		#definition -> self element cDeclaration.
	} asDictionary
]

{ #category : 'generating' }
CigCTypedefTemplate >> generateCType [
	
	^ self typeTemplate generateCType
]

{ #category : 'accessing' }
CigCTypedefTemplate >> type [

	^ type ifNil: [ type := self element resolveType ]
]

{ #category : 'accessing' }
CigCTypedefTemplate >> typeName [
	| typeName |
	
	self element definesFunction 
		ifTrue: [ ^ 'void*' ].
	self element definesArray 
		ifTrue: [  ^ (CigFunctionParser parse: self element underlyingTypeName) name, '*'  ].
	
	^ self element underlyingTypeName 
	
]

{ #category : 'accessing' }
CigCTypedefTemplate >> typeTemplate [

	^ CigCParameterTemplate 
		forType: self type 
		ofElement: self element
]
