Class {
	#name : 'IGCParameterStructTypeTemplate',
	#superclass : 'IGCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCParameterStructTypeTemplate class >> handlesType: type [

	^ type isStructure and: [ type isClass not ]
]

{ #category : 'generating' }
IGCParameterStructTypeTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << 'return ' << '(' << self generateCType << ')(' << aString << ')' ]
]

{ #category : 'generating' }
IGCParameterStructTypeTemplate >> generateArgument [
	
	self type hasElement ifFalse: [ ^ self element name ]. 
	^ String streamContents: [ :stream | 
		stream << '('.
		stream << self type parseType name.
		self type parseType arity timesRepeat: [ 
			stream << '*' ].
		stream << ')'. 
		stream << self element name ]
]

{ #category : 'generating' }
IGCParameterStructTypeTemplate >> generateCType [
	| typeName  startArity parsed |
	
	typeName := (self elementAtPath: (self type typeReference typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
		ifNil: [ typeName ].

	startArity := 0.
	parsed := self type parseType.
	
	^ String streamContents: [ :stream |
		stream << 'struct ' << typeName.
		(1 + startArity) to: parsed arity do: [ :each |
			stream << '*' ] ]
]
