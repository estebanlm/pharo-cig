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

{ #category : 'private' }
CigCParameterDeclarationTemplate >> addCastTo: stream [
	
	stream << '('.
	self type hasElement 
		ifTrue: [ stream << self type element cppDeclaration ]
		ifFalse: [ stream << self type name ].
	self type parseType arity 
		timesRepeat: [ stream << '*' ].
	stream << ')'
]

{ #category : 'private' }
CigCParameterDeclarationTemplate >> addFunctionCastTo: stream [
	
	stream << '(' << self type name << ')'
]

{ #category : 'private' }
CigCParameterDeclarationTemplate >> anonymousName [
	| index |
	
	index := (self element parent elements 
		select: [ :each | each kind = self element kind and: [ each name isEmpty ] ])
		indexOf: self element.
		
	^ 'noname_{1}' format: { index }
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
		self type requiresCast 
			ifTrue: [ self addCastTo: stream ]
			ifFalse: [ 
				self type definesFunction 
					ifTrue: [ self addFunctionCastTo: stream ] ].
		stream << self element name ]
]

{ #category : 'generating' }
CigCParameterDeclarationTemplate >> generateCType [
	| typeName parsed startArity |

	startArity := 0.
	parsed := self type parseType.
	typeName := parsed name.
	
	^ String streamContents: [ :stream |

		self type isConst 
			ifTrue: [ stream << 'const ' ].
		
		stream << (self type element 
			ifNotNil: [ :anElement | anElement cDeclaration ]
			ifNil: [ typeName ]).
		(1 + startArity) to: parsed arity do: [ :each |
			stream << '*' ] ]
]
