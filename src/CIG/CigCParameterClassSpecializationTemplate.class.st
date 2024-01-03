Class {
	#name : 'CigCParameterClassSpecializationTemplate',
	#superclass : 'CigCParameterClassTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterClassSpecializationTemplate class >> handlesType: type [

	^ type isReference not 
		and: [ type isClass 
		and: [ type isTemplateSpecialization ] ]
]

{ #category : 'generating' }
CigCParameterClassSpecializationTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '*('. 
		stream << (self type element cppDeclaration).
		stream << '<' << self specializationTypes << '>'.
		stream << '*)'.
		stream << self element name ]
]

{ #category : 'accessing' }
CigCParameterClassSpecializationTemplate >> specializationTypes [
	
	^ self type parent specializationTypes asCommaString
]
