Class {
	#name : 'IGCParameterSelfTemplate',
	#superclass : 'IGCParameterClassTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCParameterSelfTemplate class >> handlesType: aType [

	^ false
]

{ #category : 'as yet unclassified' }
IGCParameterSelfTemplate >> generateCast [
	
	^ String streamContents: [ :stream | 
		stream << '(' << self element cppDeclaration << '*' << ')' << self name ]
]

{ #category : 'accessing' }
IGCParameterSelfTemplate >> name [

	^ 'self'
]

{ #category : 'accessing' }
IGCParameterSelfTemplate >> type [

	^ type ifNil: [ type := self element resolveType ]
]
