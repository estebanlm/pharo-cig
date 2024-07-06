"
This template handles arrays of structure parameters (e.g. struct mystruct *arg).
"
Class {
	#name : 'CigCParameterArrayOfStructTypeTemplate',
	#superclass : 'CigCParameterStructTypeTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterArrayOfStructTypeTemplate class >> handlesType: type [

	^ type isStructure 
		and: [ type isClass not
		and: [ type isPointer not
		and: [ type isArray ] ] ]
]

{ #category : 'generating' }
CigCParameterArrayOfStructTypeTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << 'return (' << self generateCType << ')(' << aString << ')' ]
]

{ #category : 'generating' }
CigCParameterArrayOfStructTypeTemplate >> generateFFIType [
	| startArity parsed |

	startArity := 0.
	parsed := self type parseType.
	^ String streamContents: [ :stream |
		stream << super generateFFIType.
		(1 + startArity) to: parsed arity do: [ :each |
			stream << '_pointer' ].
		stream << '_' << parsed arrayNumber asString ]
]
