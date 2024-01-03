Class {
	#name : 'CigCParameterClassPointerTemplate',
	#superclass : 'CigCParameterClassTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterClassPointerTemplate class >> handlesType: type [

	^ type isReference not 
		and: [ type isClass
		and: [ type isTemplateSpecialization not
		and: [ type isPointer ] ] ]
]

{ #category : 'generating' }
CigCParameterClassPointerTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << 'return (' << self generateCType << ')(' << aString << ')' ]
]

{ #category : 'generating' }
CigCParameterClassPointerTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '(' << (self type element cppDeclaration) << '*)' << self element name ]
]
