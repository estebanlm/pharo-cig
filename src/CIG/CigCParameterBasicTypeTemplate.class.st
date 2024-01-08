Class {
	#name : 'CigCParameterBasicTypeTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'generating' }
CigCParameterBasicTypeTemplate >> castReturn: aString [ 
	| cast |
	
	cast := String streamContents: [ :stream | 
		self type isConst
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
CigCParameterBasicTypeTemplate >> generateArgument [
	
	^ String streamContents: [ :stream | 
		self type isReference 
			ifTrue: [ stream << '*' ].
		self type hasElement 
			ifTrue: [ stream << '(' << self type parseType name << ')' << self element name ]
			ifFalse: [ stream << self element name ] ]
]

{ #category : 'generating' }
CigCParameterBasicTypeTemplate >> generateCType [
	| typeName parsed startArity |

	startArity := 0.
	parsed := self type parseType.
	typeName := parsed name.
	
	^ String streamContents: [ :stream |
		"there may still be a typedef type (format namespace::type), we just 
	    replace that"
		| path |
		
		self type isConst 
			ifTrue: [ stream << 'const ' ].
		
		path := typeName substrings: '::'.
		stream << ((self elementAtPath: path) 
			ifNotNil: [ :anElement | anElement cDeclaration ]
			ifNil: [ typeName ]).
		(1 + startArity) to: parsed arity do: [ :each |
			stream << '*' ] ]
]

{ #category : 'generating' }
CigCParameterBasicTypeTemplate >> generateFFIType [
	
	^ CigType resolveFFIType: self generateCType
]
