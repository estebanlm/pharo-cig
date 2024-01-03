"
This is a reference to a class pointer.
e.g. MyClass *&
"
Class {
	#name : 'CigCParameterPointerToClassReferenceTemplate',
	#superclass : 'CigCParameterClassReferenceTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterPointerToClassReferenceTemplate class >> handlesType: type [

	^ type isReference 
		and: [ type isClass
		and: [ type isPointer 
		and: [ type pointerArity > 1 ] ] ]
]

{ #category : 'generating' }
CigCParameterPointerToClassReferenceTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '(' << (self type element cppDeclaration) << '*&)' << self element name ]
]
