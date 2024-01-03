Class {
	#name : 'CigCMethodTemplate',
	#superclass : 'CigCBaseFunctionTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'instance creation' }
CigCMethodTemplate class >> for: anElement [

	^ self allSubclasses 
		detect: [ :each | each handlesElement: anElement ]
		ifFound: [ :aClass | aClass forElement: anElement ]
		ifNone: [ CigCInstanceMethodTemplate forElement: anElement ]
]

{ #category : 'private' }
CigCMethodTemplate class >> handlesElement: anElement [

	^ false
]
