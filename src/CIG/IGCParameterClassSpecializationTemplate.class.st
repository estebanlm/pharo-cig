Class {
	#name : 'IGCParameterClassSpecializationTemplate',
	#superclass : 'IGCParameterClassTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCParameterClassSpecializationTemplate class >> handlesType: type [

	^ type isReference not 
		and: [ type isClass 
		and: [ type isTemplateSpecialization ] ]
]

{ #category : 'generating' }
IGCParameterClassSpecializationTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '*('. 
		stream << (self type element cppDeclaration).
		stream << '<' << self templateTypes << '>'.
		stream << '*)'.
		stream << self element name ]
]

{ #category : 'accessing' }
IGCParameterClassSpecializationTemplate >> templateTypes [
	
	^ self type parent templateTypes asCommaString
]
