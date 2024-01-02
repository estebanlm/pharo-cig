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
	| elementAtPath |

	elementAtPath := self root elementAtPath: aPath.
	"I am not interested on type references (at least for now)"
	(elementAtPath isNil or: [ elementAtPath isTypeReference ])
		ifTrue: [ ^ nil ].
		
	^ elementAtPath 
]

{ #category : 'initialization' }
IGCTemplate >> forElement: anElement [

	element := anElement
]

{ #category : 'accessing' }
IGCTemplate >> root [

	^ self element root
]
