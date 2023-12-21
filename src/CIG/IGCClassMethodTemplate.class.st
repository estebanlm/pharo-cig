Class {
	#name : 'IGCClassMethodTemplate',
	#superclass : 'IGCMethodTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCClassMethodTemplate class >> handlesElement: anElement [

	^ anElement isStatic
]

{ #category : 'private' }
IGCClassMethodTemplate >> basicGenerateBody [

	^ '{func}({arguments})'
		format: {
			#func -> self element cppDeclaration.
			#arguments -> self generateArguments.
		} asDictionary
]
