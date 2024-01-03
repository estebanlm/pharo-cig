Class {
	#name : 'CigCConstructorTemplate',
	#superclass : 'CigCMethodTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCConstructorTemplate class >> handlesElement: anElement [

	^ anElement isClassMember
		and: [ anElement isConstructor
		and: [ anElement parent hasOperatorOverloadNewManyArguments not ] ]
]

{ #category : 'private' }
CigCConstructorTemplate >> basicGenerateBody [

	^ 'new {func}({arguments})'
		format: {
			#func -> self element cppDeclaration.
			#arguments -> self generateArguments.
		} asDictionary
]

{ #category : 'generating' }
CigCConstructorTemplate >> castReturn: aString [

	^ String streamContents: [ :stream |
		stream <<  'return (' <<  self return generateCType  <<  ')(' << aString << ')' ]
]

{ #category : 'accessing' }
CigCConstructorTemplate >> return [

	^ return ifNil: [ return := CigCParameterTemplate forClass: self element parent ]
]
