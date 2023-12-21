Class {
	#name : 'IGCFunctionTemplate',
	#superclass : 'IGCBaseFunctionTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'instance creation' }
IGCFunctionTemplate class >> for: anElement [

	^ self allSubclasses
		detect: [ :each | each handlesElement: anElement ]
		ifFound: [ :aClass | aClass forElement: anElement ]
		ifNone: [ self forElement: anElement ]
]

{ #category : 'private' }
IGCFunctionTemplate class >> handlesElement: anElement [

	^ false
]

{ #category : 'private' }
IGCFunctionTemplate >> basicGenerateBody [

	^ '{func}({arguments})'
		format: {
			#func -> self element cppDeclaration.
			#arguments -> self generateArguments.
		} asDictionary
]
