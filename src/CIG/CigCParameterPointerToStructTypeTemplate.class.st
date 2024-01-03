"
This template handles pointer to structure parameters (e.g. struct mystruct *arg).
"
Class {
	#name : 'CigCParameterPointerToStructTypeTemplate',
	#superclass : 'CigCParameterStructTypeTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterPointerToStructTypeTemplate class >> handlesType: type [

	^ type isStructure 
		and: [ type isClass not
		and: [ type isPointer ] ]
]

{ #category : 'generating' }
CigCParameterPointerToStructTypeTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << 'return (' << self generateCType << ')(' << aString << ')' ]
]
