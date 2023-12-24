"
A class to handle the result (return) of a function as an output parameter.
This is used directly in `IGCFunctionReturnAsParameterTemplate`
"
Class {
	#name : 'IGCParameterReturnAsParameterTemplate',
	#superclass : 'IGCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCParameterReturnAsParameterTemplate class >> handlesType: type [

	^ false
]

{ #category : 'generating' }
IGCParameterReturnAsParameterTemplate >> castReturn: aString [ 
	
	^ aString
]

{ #category : 'generating' }
IGCParameterReturnAsParameterTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '*(' << (self type element cppDeclaration) << '*)' << self name ]
]

{ #category : 'as yet unclassified' }
IGCParameterReturnAsParameterTemplate >> generateCType [
	| typeName |
	
	typeName := self type typeReference typeName.
	^ (self elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
		ifNil: [ typeName ]
]

{ #category : 'accessing' }
IGCParameterReturnAsParameterTemplate >> name [

	^ 'result'
]

{ #category : 'accessing' }
IGCParameterReturnAsParameterTemplate >> type [

	^ type ifNil: [ type := self element resolveReturnType ]
]
