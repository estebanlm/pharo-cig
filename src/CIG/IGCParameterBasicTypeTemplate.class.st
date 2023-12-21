Class {
	#name : 'IGCParameterBasicTypeTemplate',
	#superclass : 'IGCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'generating' }
IGCParameterBasicTypeTemplate >> castReturn: aString [ 
	| cast |
	
	cast := String streamContents: [ :stream | 
		self type isTypedef
			ifTrue: [ stream << '(' << self generateCType << ')' ].
		self type isReference 
			ifTrue: [ stream << '&' ] ].
		
	^ String streamContents: [ :stream |
		stream << 'return '.
		cast 
			ifNotEmpty: [ stream << cast << '(' << aString << ')' ]
			ifEmpty: [ stream << aString ] ]
]

{ #category : 'generating' }
IGCParameterBasicTypeTemplate >> generateArgument [
	
	self type hasElement ifFalse: [ ^ self element name ]. 
	^ String streamContents: [ :stream | 
		stream << '(' << self type parseType name << ')' << self element name ]
]

{ #category : 'generating' }
IGCParameterBasicTypeTemplate >> generateCType [
	| typeName parsed startArity |

	startArity := 0.
	parsed := self type parseType.
	typeName := parsed name.
	
	^ String streamContents: [ :stream |
		"there may still be a typedef type (format namespace::type), we just 
	    replace that"
		| path |
		path := typeName substrings: '::'.
		stream << ((self elementAtPath: path) 
			ifNotNil: [ :anElement | anElement cDeclaration ]
			ifNil: [ typeName ]).
		(1 + startArity) to: parsed arity do: [ :each |
			stream << '*' ] ]
]
