Class {
	#name : 'IGCTemplate',
	#superclass : 'Object',
	#instVars : [
		'element'
	],
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'instance creation' }
IGCTemplate class >> for: anElement [

	^ self forElement: anElement
]

{ #category : 'private' }
IGCTemplate class >> forElement: anElement [

	^ self new forElement: anElement
]

{ #category : 'accessing' }
IGCTemplate >> element [

	^ element
]

{ #category : 'accessing' }
IGCTemplate >> elementAtPath: aPath [

	^ self root elementAtPath: aPath
]

{ #category : 'initialization' }
IGCTemplate >> forElement: anElement [

	element := anElement
]

{ #category : 'accessing' }
IGCTemplate >> root [

	^ self element root
]
