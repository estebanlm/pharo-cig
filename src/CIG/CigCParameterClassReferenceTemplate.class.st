"
This is a class reference (not pointer).
E.g. MyClass &
"
Class {
	#name : 'CigCParameterClassReferenceTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterClassReferenceTemplate class >> handlesType: type [

	^ type isReference 
		and: [ type isClass
		and: [ (type isPointer not) or: [ type pointerArity = 1 ] ] ]
]

{ #category : 'generating' }
CigCParameterClassReferenceTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << 'return ' << '(' << self generateCType << ')'.
		self type isReference
			ifTrue: [ stream << '&' ].
		stream << '(' << aString << ')' ]
]

{ #category : 'generating' }
CigCParameterClassReferenceTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '*(' << (self type element cppDeclaration) << '*)' << self element name ]
]

{ #category : 'generating' }
CigCParameterClassReferenceTemplate >> generateCType [
	| typeName |
	
	self type hasElement ifTrue: [ ^ self type element cDeclaration ].
	
	typeName := self type typeReference typeName.
	^ (self elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
		ifNil: [ typeName ]
]
