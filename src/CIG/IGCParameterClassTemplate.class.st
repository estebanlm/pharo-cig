Class {
	#name : 'IGCParameterClassTemplate',
	#superclass : 'IGCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCParameterClassTemplate class >> handlesType: type [

	^ type isReference not 
		and: [ type isClass ]
]

{ #category : 'generating' }
IGCParameterClassTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << '(' << self generateCType << ')(' << aString << ')' ]
]

{ #category : 'generating' }
IGCParameterClassTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '*(' << (self type element cppDeclaration) << '*)' << self element name ]
]

{ #category : 'generating' }
IGCParameterClassTemplate >> generateCType [
	| typeName |
	
	typeName := self type typeReference typeName.
	^ (self elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
		ifNil: [ typeName ]
]
