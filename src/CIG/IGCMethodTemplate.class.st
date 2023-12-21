Class {
	#name : 'IGCMethodTemplate',
	#superclass : 'IGCBaseFunctionTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'instance creation' }
IGCMethodTemplate class >> for: anElement [

	^ self allSubclasses 
		detect: [ :each | each handlesElement: anElement ]
		ifFound: [ :aClass | aClass forElement: anElement ]
		ifNone: [ IGCInstanceMethodTemplate forElement: anElement ]
]

{ #category : 'private' }
IGCMethodTemplate class >> handlesElement: anElement [

	^ false
]
