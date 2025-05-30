"
A template to build function calls.
"
Class {
	#name : 'CigPharoFunctionTemplate',
	#superclass : 'CigPharoTemplate',
	#category : 'CIG-Pharo-Template',
	#package : 'CIG',
	#tag : 'Pharo-Template'
}

{ #category : 'instance creation' }
CigPharoFunctionTemplate class >> for: anElement [

	^ self allSubclasses 
		detect: [ :each | each handlesElement: anElement ]
		ifFound: [ :aClass | aClass forElement: anElement ]
		ifNone: [ CigPharoFunctionTemplate forElement: anElement ]
]

{ #category : 'private' }
CigPharoFunctionTemplate class >> handlesElement: anElement [

	^ false
]

{ #category : 'private' }
CigPharoFunctionTemplate >> buildParameters: aCollection on: stream [ 
	
	aCollection ifEmpty: [ ^ self ].
	
	aCollection first in: [ :each | 
		aCollection size > self parameterSizeForNameThreshold
			ifTrue: [ stream << each name capitalized ].
		stream << ': ' << each name << ' ' ].
	aCollection allButFirst do: [ :each | 
		stream << each name << ': ' << each name << ' ' ]
]

{ #category : 'generating' }
CigPharoFunctionTemplate >> generate [

	^ String streamContents: [ :stream |
		stream << self generateHeader; cr.
		self element hasComment
			ifTrue: [ stream << self generateComment; cr ].
		stream cr.
		stream tab.
		self element isReturnTypeVoid ifFalse: [ stream nextPutAll: '^ ' ].
		stream << 'self ffiCall: #(' << self element cTemplate generateHeaderForFFI << ')' ]
]

{ #category : 'generating' }
CigPharoFunctionTemplate >> generateComment [

	^ String streamContents: [ :stream |
		stream tab.
		stream << '"'.
		self element comment lines 
			do: [ :each | stream << (each copyReplaceAll: '"' with: '""') trimmed ]
			separatedBy: [ stream cr; tab; space ].
		stream << '"' ]
]

{ #category : 'generating' }
CigPharoFunctionTemplate >> generateHeader [
	
	^ self element phDeclaration
]

{ #category : 'private' }
CigPharoFunctionTemplate >> parameterSizeForNameThreshold [

	^ 1
]

{ #category : 'private' }
CigPharoFunctionTemplate >> parameters [

	^ self element parameters
]
