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
		stream << 'auto _tmp = ' << aString << ';'; cr.
		stream << 'auto _result = std::make_unique<' << self type element cppDeclaration << '>(_tmp);'; cr.
		stream << 'return (' << self generateCType << ')_result.release()' ]
]

{ #category : 'generating' }
CigCParameterClassTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '*(' << (self type element cppDeclaration) << '*)' << self element name ]
]

{ #category : 'generating' }
CigCParameterClassTemplate >> generateCType [
	
	^ self type element cDeclaration
]
