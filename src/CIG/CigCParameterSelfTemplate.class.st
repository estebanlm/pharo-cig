"
A class to handle ""self"" (the class instance) as a parameter.
This is used internally in the `IGCMethodTemplate` hierarchy.
"
Class {
	#name : 'CigCParameterSelfTemplate',
	#superclass : 'CigCParameterClassTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCParameterSelfTemplate class >> handlesType: aType [

	^ false
]

{ #category : 'generating' }
CigCParameterSelfTemplate >> generateCast [
	
	^ String streamContents: [ :stream | 
		stream << '(' << self element cppDeclaration << '*' << ')' << self name ]
]

{ #category : 'accessing' }
CigCParameterSelfTemplate >> name [

	^ 'self'
]

{ #category : 'accessing' }
CigCParameterSelfTemplate >> type [

	^ type ifNil: [ type := self element resolveType ]
]
