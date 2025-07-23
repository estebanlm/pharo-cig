Class {
	#name : 'CigPharoVariadicTemplate',
	#superclass : 'CigPharoTemplate',
	#category : 'CIG-Pharo-Template',
	#package : 'CIG',
	#tag : 'Pharo-Template'
}

{ #category : 'generating' }
CigPharoVariadicTemplate >> generate [
	^ String streamContents: [ :stream |
		stream << self generateHeader; cr.
		stream cr.
		stream tab.
		self element isReturnTypeVoid ifFalse: [ stream nextPutAll: '^ ' ].
		stream << 'self ffiCall: #(' << self element cDeclaration << ')' ]
]

{ #category : 'generating' }
CigPharoVariadicTemplate >> generateHeader [
	| parsed |

	parsed := self element parsedFunction.
	parsed arguments size > 0 
		ifFalse: [ self element selector ].
	
	^ (String streamContents: [ :stream |
		(self element selector findTokens: $:)
			withIndexDo: [ :each :index | 
				stream 
					<< each << ': ' << (parsed arguments at: index) name
					<< ' ' ] ])
		trimmed
]
