Class {
	#name : 'CigCFunctionTemplate',
	#superclass : 'CigCBaseFunctionTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'instance creation' }
CigCFunctionTemplate class >> for: anElement [

	^ self allSubclasses
		detect: [ :each | each handlesElement: anElement ]
		ifFound: [ :aClass | aClass forElement: anElement ]
		ifNone: [ self forElement: anElement ]
]

{ #category : 'private' }
CigCFunctionTemplate class >> handlesElement: anElement [

	^ false
]

{ #category : 'private' }
CigCFunctionTemplate >> basicGenerateBody [

	^ '{func}({arguments})'
		format: {
			#func -> self element cppDeclaration.
			#arguments -> self generateArguments.
		} asDictionary
]
