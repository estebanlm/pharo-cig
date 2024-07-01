Class {
	#name : 'CigCParameterImportedNamespaceElementTypeTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterImportedNamespaceElementTypeTemplate class >> handlesType: aType [

	^ aType isImportedNamespaceElement
]

{ #category : 'generating' }
CigCParameterImportedNamespaceElementTypeTemplate >> castReturn: aString [ 
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
CigCParameterImportedNamespaceElementTypeTemplate >> generateArgument [
	
	^ String streamContents: [ :stream | 
		self type isReference 
			ifTrue: [ stream << '*' ].
		self type hasElement 
			ifTrue: [ stream << '(' << self type parseType name << ')' << self element name ]
			ifFalse: [ stream << self element name ] ]
]

{ #category : 'generating' }
CigCParameterImportedNamespaceElementTypeTemplate >> generateCType [

	^ self type element cDeclaration
]

{ #category : 'generating' }
CigCParameterImportedNamespaceElementTypeTemplate >> generateFFIType [
	
	^ CigType resolveFFIType: self generateCType
]
