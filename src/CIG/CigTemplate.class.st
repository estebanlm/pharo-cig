"
Base template for generations.
"
Class {
	#name : 'CigTemplate',
	#superclass : 'Object',
	#instVars : [
		'element'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'instance creation' }
CigTemplate class >> for: anElement [

	^ self forElement: anElement
]

{ #category : 'instance creation' }
CigTemplate class >> forElement: anElement [

	^ self new forElement: anElement
]

{ #category : 'accessing' }
CigTemplate >> element [

	^ element
]

{ #category : 'initialization' }
CigTemplate >> forElement: anElement [

	element := anElement
]
