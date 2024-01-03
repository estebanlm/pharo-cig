Class {
	#name : 'CigCClassMethodTemplate',
	#superclass : 'CigCMethodTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCClassMethodTemplate class >> handlesElement: anElement [

	^ anElement isClassMember and: [ anElement isStatic ]
]

{ #category : 'private' }
CigCClassMethodTemplate >> basicGenerateBody [

	^ '{func}({arguments})'
		format: {
			#func -> self element cppDeclaration.
			#arguments -> self generateArguments.
		} asDictionary
]
