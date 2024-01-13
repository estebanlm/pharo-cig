Class {
	#name : 'CigCParameterEnumReferenceTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterEnumReferenceTemplate class >> handlesType: type [

	^ type isEnum
]

{ #category : 'generating' }
CigCParameterEnumReferenceTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << 'return ' << '(' << self generateCType << ')(' << aString << ')' ]
]

{ #category : 'generating' }
CigCParameterEnumReferenceTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '(' << (self type element cppDeclaration) << ')' << self element name ]
]

{ #category : 'generating' }
CigCParameterEnumReferenceTemplate >> generateCType [
	| typeName |
	
	self type hasElement ifTrue: [ ^ self type element cDeclaration ].
	
	typeName := self type typeReference typeName.
	^ (self elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
		ifNil: [ typeName ]
]
