Class {
	#name : 'CigCParameterDeclarationTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'nil' }
CigCParameterDeclarationTemplate class >> handlesType: aType [

	^ aType isAnyDeclaration
]

{ #category : 'generating' }
CigCParameterDeclarationTemplate >> castReturn: aString [ 
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
CigCParameterDeclarationTemplate >> generateArgument [
	
	^ String streamContents: [ :stream | 
		self type isReference 
			ifTrue: [ stream << '*' ].
		self type requiresCast ifTrue: [ 
			stream << '('.
			self type hasElement 
				ifTrue: [ stream << self type element cppDeclaration ]
				ifFalse: [ stream << self type name ].
			self type parseType arity 
				timesRepeat: [ stream << '*' ].
			stream << ')' ].
		stream << self element name ]
]

{ #category : 'generating' }
CigCParameterDeclarationTemplate >> generateCType [
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
		
		stream << (self type element 
			ifNotNil: [ :anElement | anElement cDeclaration ]
			ifNil: [ typeName ]).
		(1 + startArity) to: parsed arity do: [ :each |
			stream << '*' ] ]
]
