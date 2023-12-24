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
		and: [ type isClass 
		and: [ type isTemplateSpecialization not
		and: [ type isPointer not ] ] ]
]

{ #category : 'generating' }
IGCParameterClassTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream |
		stream << 'auto _result = new ' << self type name << '();'; cr.
		stream << '*_result = ' << aString << ';'; cr.
		stream << 'return (' << self generateCType << ')_result' ]
]

{ #category : 'generating' }
IGCParameterClassTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '*(' << (self type element cppDeclaration) << '*)' << self element name ]
]

{ #category : 'as yet unclassified' }
IGCParameterClassTemplate >> generateCType [
	
	^ self type element cDeclaration
]
