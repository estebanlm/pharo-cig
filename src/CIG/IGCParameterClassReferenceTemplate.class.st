Class {
	#name : 'IGCParameterClassReferenceTemplate',
	#superclass : 'IGCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCParameterClassReferenceTemplate class >> handlesType: type [

	^ type isReference 
		and: [ type isClass ]
]

{ #category : 'generating' }
IGCParameterClassReferenceTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << '(' << self generateCType << ')(' << aString << ')' ]
]

{ #category : 'generating' }
IGCParameterClassReferenceTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '*(' << (self type element cppDeclaration) << '*)' << self element name ]
]

{ #category : 'generating' }
IGCParameterClassReferenceTemplate >> generateCType [
	| typeName |
	
	typeName := self type typeReference typeName.
	^ (self elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
		ifNil: [ typeName ]
]
