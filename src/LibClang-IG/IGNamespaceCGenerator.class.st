Class {
	#name : 'IGNamespaceCGenerator',
	#superclass : 'Object',
	#instVars : [
		'namespace',
		'stream'
	],
	#category : 'LibClang-IG',
	#package : 'LibClang-IG'
}

{ #category : 'as yet unclassified' }
IGNamespaceCGenerator >> appendFunction: aFunction [

	stream << ('{1} \{
	{5} {2}::{3}({4});
\}

' format: { 
	aFunction asFunctionDeclarationWithPrefix: self namespace name.
	self namespace name.
	aFunction spelling.
	aFunction argumentsAsList.
	aFunction isReturnTypeVoid 
		ifTrue: [ '' ]
		ifFalse: [ 'return ' ]  })
]

{ #category : 'accessing' }
IGNamespaceCGenerator >> namespace [

	^ namespace
]

{ #category : 'accessing' }
IGNamespaceCGenerator >> namespace: aNamespace [

	namespace := aNamespace
]

{ #category : 'accessing' }
IGNamespaceCGenerator >> stream [

	^ stream
]

{ #category : 'accessing' }
IGNamespaceCGenerator >> stream: aStream [

	stream := aStream
]
