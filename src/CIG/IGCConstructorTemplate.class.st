Class {
	#name : 'IGCConstructorTemplate',
	#superclass : 'IGCMethodTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCConstructorTemplate class >> handlesElement: anElement [

	^ anElement isConstructor
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
		stream << 'return ' << (self return castReturn: aString) ]
]

{ #category : 'accessing' }
IGCConstructorTemplate >> return [

	^ return ifNil: [ return := IGCParameterTemplate forClass: self element parent ]
]
