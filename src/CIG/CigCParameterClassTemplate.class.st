Class {
	#name : 'CigCParameterClassTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterClassTemplate class >> handlesType: type [

	^ type isReference not 
		and: [ type isClass 
		and: [ type isTemplateSpecialization not
		and: [ type isPointer not ] ] ]
]

{ #category : 'generating' }
CigCParameterClassTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream |
		stream << 'auto _result = new ' << self type element cppDeclaration << '();'; cr.
		stream << '*_result = ' << aString << ';'; cr.
		stream << 'return (' << self generateCType << ')_result' ]
]

{ #category : 'generating' }
CigCParameterClassTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '*(' << (self type element cppDeclaration) << '*)' << self element name ]
]

{ #category : 'as yet unclassified' }
CigCParameterClassTemplate >> generateCType [
	
	^ self type element cDeclaration
]
