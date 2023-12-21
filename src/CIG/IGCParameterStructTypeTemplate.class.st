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
	| name |
	
	self type hasElement ifFalse: [ ^ self element name ]. 
	name := self type parseType name.
	^ String streamContents: [ :stream | 
		self type isReference 
			ifTrue: [ stream << '*' ].
		stream << '('.
		"a type struct may or may not come with implicit name"
		(name beginsWith: 'struct ')
			ifFalse: [ stream << 'struct ' ].
		stream << name.
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
