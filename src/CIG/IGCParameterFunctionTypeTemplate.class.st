Class {
	#name : 'IGCParameterFunctionTypeTemplate',
	#superclass : 'IGCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCParameterFunctionTypeTemplate class >> handlesType: aType [

	^ aType isFunction
]

{ #category : 'generating' }
IGCParameterFunctionTypeTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream |
		stream << 'return (void*)' << aString ]
]

{ #category : 'generating' }
IGCParameterFunctionTypeTemplate >> generateArgument [
	
	self type hasElement ifFalse: [ ^ self element name ]. 
	^ String streamContents: [ :stream | 
		stream << '(' << self type parseType name << ')' << self element name ]
]

{ #category : 'generating' }
IGCParameterFunctionTypeTemplate >> generateCType [

	^ 'void*'
]
