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

{ #category : 'generating' }
CigCParameterPointerToStructTypeTemplate >> generateFFIType [
	| startArity parsed |

	startArity := 0.
	parsed := self type parseType.
	^ String streamContents: [ :stream |
		stream << super generateFFIType.
		(1 + startArity) to: parsed arity do: [ :each |
			stream << '*' ] ]
]
