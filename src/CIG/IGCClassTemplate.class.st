Class {
	#name : 'IGCClassTemplate',
	#superclass : 'IGCTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'helpers' }
IGCClassTemplate class >> for: aClass [

	^ self allSubclasses
		detect: [ :each | each handlesElement: aClass ]
		ifFound: [ :aTemplate | aTemplate forElement: aClass ]
		ifNone: [ IGCClassDefaultTemplate forElement: aClass ]
]

{ #category : 'private' }
IGCClassTemplate class >> handlesElement: anElement [

	^ false
]

{ #category : 'generating' }
IGCClassTemplate >> generateHeader [
	
	^ self subclassResponsibility
]
