Class {
	#name : 'CigCTemplate',
	#superclass : 'Object',
	#instVars : [
		'element'
	],
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'instance creation' }
CigCTemplate class >> for: anElement [

	^ self forElement: anElement
]

{ #category : 'private' }
CigCTemplate class >> forElement: anElement [

	^ self new forElement: anElement
]

{ #category : 'accessing' }
CigCTemplate >> element [

	^ element
]

{ #category : 'accessing' }
CigCTemplate >> elementAtPath: aPath [
	| elementAtPath |

	elementAtPath := self root elementAtPath: aPath.
	"I am not interested on type references (at least for now)"
	(elementAtPath isNil or: [ elementAtPath isTypeReference ])
		ifTrue: [ ^ nil ].
		
	^ elementAtPath 
]

{ #category : 'initialization' }
CigCTemplate >> forElement: anElement [

	element := anElement
]

{ #category : 'accessing' }
CigCTemplate >> root [

	^ self element root
]
