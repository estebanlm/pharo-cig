"
base template for C templates (templates used for C generation)
"
Class {
	#name : 'CigCTemplate',
	#superclass : 'CigTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'accessing' }
CigCTemplate >> elementAtPath: aPath [
	| elementAtPath |

	elementAtPath := self root elementAtPath: aPath.
	"I am not interested on type references (at least for now)"
	(elementAtPath isNil or: [ elementAtPath isTypeReference ])
		ifTrue: [ ^ nil ].
		
	^ elementAtPath 
]

{ #category : 'accessing' }
CigCTemplate >> root [

	^ self element root
]
