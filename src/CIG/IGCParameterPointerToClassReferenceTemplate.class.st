Class {
	#name : 'IGCParameterPointerToClassReferenceTemplate',
	#superclass : 'IGCParameterClassReferenceTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCParameterPointerToClassReferenceTemplate class >> handlesType: type [

	^ type isReference 
		and: [ type isClass
		and: [ type isPointer 
		and: [ type pointerArity > 1 ] ] ]
]

{ #category : 'generating' }
IGCParameterPointerToClassReferenceTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '(' << (self type element cppDeclaration) << '*&)' << self element name ]
]
