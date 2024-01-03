"
A class to handle the result (return) of a function as an output parameter.
This is used directly in `IGCFunctionReturnAsParameterTemplate`
"
Class {
	#name : 'CigCParameterReturnAsParameterTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterReturnAsParameterTemplate class >> handlesType: type [

	^ false
]

{ #category : 'generating' }
CigCParameterReturnAsParameterTemplate >> castReturn: aString [ 
	
	^ aString
]

{ #category : 'generating' }
CigCParameterReturnAsParameterTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '*(' << (self type element cppDeclaration) << '*)' << self name ]
]

{ #category : 'as yet unclassified' }
CigCParameterReturnAsParameterTemplate >> generateCType [
	| typeName typeReference |
	
	typeReference := self type typeReference. 
	typeReference ifNil: [ ^ self type name ].
	
	typeName := typeReference typeName.
	^ (self elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
		ifNil: [ typeName ]
]

{ #category : 'accessing' }
CigCParameterReturnAsParameterTemplate >> name [

	^ 'result'
]

{ #category : 'accessing' }
CigCParameterReturnAsParameterTemplate >> type [

	^ type ifNil: [ type := self element resolveReturnType ]
]
