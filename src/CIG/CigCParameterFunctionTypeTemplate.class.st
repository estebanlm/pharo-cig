Class {
	#name : 'CigCParameterFunctionTypeTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterFunctionTypeTemplate class >> handlesType: aType [

	^ aType isFunction
]

{ #category : 'generating' }
CigCParameterFunctionTypeTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream |
		stream << 'return (void*)' << aString ]
]

{ #category : 'generating' }
CigCParameterFunctionTypeTemplate >> generateArgument [
	
	^ String streamContents: [ :stream | 
		stream << '(' << self type name << ')' << self element name ]
]

{ #category : 'generating' }
CigCParameterFunctionTypeTemplate >> generateCType [

	^ 'void*'
]
