Class {
	#name : 'CigCClassTemplate',
	#superclass : 'CigCTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'helpers' }
CigCClassTemplate class >> for: aClass [

	^ self allSubclasses
		detect: [ :each | each handlesElement: aClass ]
		ifFound: [ :aTemplate | aTemplate forElement: aClass ]
		ifNone: [ CigCClassDefaultTemplate forElement: aClass ]
]

{ #category : 'private' }
CigCClassTemplate class >> handlesElement: anElement [

	^ false
]

{ #category : 'generating' }
CigCClassTemplate >> generateHeader [
	
	^ self subclassResponsibility
]
