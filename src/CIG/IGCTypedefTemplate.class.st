Class {
	#name : 'IGCTypedefTemplate',
	#superclass : 'IGCTemplate',
	#instVars : [
		'type'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'generating' }
IGCTypedefTemplate >> generate [

	^ 'typedef {cType} {definition};' 
	format: { 
		#cType -> self typeName.
		#definition -> self element cDeclaration.
	} asDictionary
]

{ #category : 'generating' }
IGCTypedefTemplate >> generateCType [
	
	^ self typeTemplate generateCType
]

{ #category : 'accessing' }
IGCTypedefTemplate >> type [

	^ type ifNil: [ type := self element resolveType ]
]

{ #category : 'accessing' }
IGCTypedefTemplate >> typeName [
	| typeName |
	
	self element definesFunction 
		ifTrue: [ ^ 'void*' ].
	self element definesArray 
		ifTrue: [  ^ (IGFunctionParser parse: self element underlyingTypeName) name, '*'  ].
	
	^ self element underlyingTypeName 
	
]

{ #category : 'accessing' }
IGCTypedefTemplate >> typeTemplate [

	^ IGCParameterTemplate 
		forType: self type 
		ofElement: self element
]
