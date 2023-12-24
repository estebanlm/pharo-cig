Class {
	#name : 'IGCParameterClassReferenceTemplate',
	#superclass : 'IGCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCParameterClassReferenceTemplate class >> handlesType: type [

	^ type isReference 
		and: [ type isClass
		and: [ (type isPointer not) or: [ type pointerArity = 1 ] ] ]
]

{ #category : 'generating' }
IGCParameterClassReferenceTemplate >> castReturn: aString [ 
	
	^ String streamContents: [ :stream | 
		stream << 'return ' << '(' << self generateCType << ')'.
		self type isReference
			ifTrue: [ stream << '&' ].
		stream << '(' << aString << ')' ]
]

{ #category : 'generating' }
IGCParameterClassReferenceTemplate >> generateArgument [
	
	^ String streamContents: [ :stream |
		stream << '*(' << (self type element cppDeclaration) << '*)' << self element name ]
]

{ #category : 'as yet unclassified' }
IGCParameterClassReferenceTemplate >> generateCType [
	| typeName |
	
	typeName := self type typeReference typeName.
	^ (self elementAtPath: (typeName substrings: '::'))
		ifNotNil: [ :aNode | aNode cDeclaration ]
		ifNil: [ typeName ]
]
