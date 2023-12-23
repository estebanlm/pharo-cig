Class {
	#name : 'IGCConstructorTemplate',
	#superclass : 'IGCMethodTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCConstructorTemplate class >> handlesElement: anElement [

	^ anElement isClassMember
		and: [ anElement isConstructor
		and: [ anElement parent hasOperatorOverloadNewManyArguments not ] ]
]

{ #category : 'private' }
IGCConstructorTemplate >> basicGenerateBody [

	^ 'new {func}({arguments})'
		format: {
			#func -> self element cppDeclaration.
			#arguments -> self generateArguments.
		} asDictionary
]

{ #category : 'generating' }
IGCConstructorTemplate >> castReturn: aString [

	^ String streamContents: [ :stream |
		stream <<  'return (' <<  self return generateCType  <<  ')(' << aString << ')' ]
]

{ #category : 'accessing' }
IGCConstructorTemplate >> return [

	^ return ifNil: [ return := IGCParameterTemplate forClass: self element parent ]
]
