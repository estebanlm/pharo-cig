Class {
	#name : 'IGCFunctionTemplate',
	#superclass : 'IGCBaseFunctionTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCFunctionTemplate >> basicGenerateBody [

	^ '{func}({arguments})'
		format: {
			#func -> self element cppDeclaration.
			#arguments -> self generateArguments.
		} asDictionary
]
