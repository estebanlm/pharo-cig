"
This template handles pointer to structure parameters (e.g. struct mystruct *arg).
"
Class {
	#name : 'IGCParameterPointerToStructTypeTemplate',
	#superclass : 'IGCParameterStructTypeTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCParameterPointerToStructTypeTemplate class >> handlesType: type [

	^ type isStructure 
		and: [ type isClass not
		and: [ type isPointer ] ]
]

{ #category : 'generating' }
IGCParameterPointerToStructTypeTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << 'return (' << self generateCType << ')(' << aString << ')' ]
]
