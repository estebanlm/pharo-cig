Class {
	#name : 'IGCParameterClassPointerTemplate',
	#superclass : 'IGCParameterClassTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCParameterClassPointerTemplate class >> handlesType: type [

	^ type isReference not 
		and: [ type isClass
		and: [ type isTemplateSpecialization not
		and: [ type isPointer ] ] ]
]

{ #category : 'generating' }
IGCParameterClassPointerTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << 'return (' << self generateCType << ')(' << aString << ')' ]
]

{ #category : 'generating' }
IGCParameterClassPointerTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '(' << (self type element cppDeclaration) << '*)' << self element name ]
]

{ #category : 'generating' }
IGCParameterClassPointerTemplate >> generateCType [
	| typeName |
	
	typeName := self type typeReference typeName.
	^ (self elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
		ifNil: [ typeName ]
]
