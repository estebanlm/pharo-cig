Class {
	#name : 'IGIndentWriteStream',
	#superclass : 'WriteStream',
	#instVars : [
		'stream',
		'indent'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'instance creation' }
IGIndentWriteStream class >> on: aStream [

	^ self basicNew
		initialize;
		stream: aStream;
		yourself
]

{ #category : 'accessing' }
IGIndentWriteStream >> decrement [

	indent = 0 ifTrue: [ ^ self ].
	indent := indent - 1
]

{ #category : 'accessing' }
IGIndentWriteStream >> increment [

	indent := indent + 1
]

{ #category : 'accessing' }
IGIndentWriteStream >> indent [

	^ indent
]

{ #category : 'accessing' }
IGIndentWriteStream >> indentDo: aBlock [

	self increment.
	aBlock ensure: [ self decrement ]
]

{ #category : 'accessing' }
IGIndentWriteStream >> indentString [

	indent = 0 ifTrue: [ ^ '' ].
	
	^ String 
		new: self indent 
		withAll: Character tab
]

{ #category : 'initialization' }
IGIndentWriteStream >> initialize [

	super initialize.
	indent := 0
]

{ #category : 'accessing' }
IGIndentWriteStream >> nextPut: anObject [
	
	stream nextPut: anObject
]

{ #category : 'accessing' }
IGIndentWriteStream >> nextPutAll: aString [
	| indentString |
	
	indentString := self indentString.
	aString lineIndicesDo: [:start :endWithoutDelimiters :end |
		stream nextPutAll: indentString.
		stream nextPutAll: (aString copyFrom: start to: end) ]
]

{ #category : 'accessing' }
IGIndentWriteStream >> stream: aStream [

	stream := aStream
]
