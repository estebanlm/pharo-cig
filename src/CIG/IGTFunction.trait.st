Trait {
	#name : 'IGTFunction',
	#instVars : [
		'returnTypeName',
		'spelling',
		'comment',
		'parameters'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGTFunction >> argumentsAsList [

	^ (self parameters collect: [ :each | each asArgumentString ]) asCommaString
]

{ #category : 'private' }
IGTFunction >> buildParameters: aCollection on: stream [ 
	
	aCollection ifEmpty: [ ^ self ].
	
	aCollection first in: [ :each | 
		aCollection size > 1 
			ifTrue: [ stream << each name capitalized ].
		stream << ': ' << each name << ' ' ].
	aCollection allButFirst do: [ :each | 
		stream << each name << ': ' << each name << ' ' ]
]

{ #category : 'accessing' }
IGTFunction >> comment [

	^ comment	
]

{ #category : 'private' }
IGTFunction >> disambiguate: aString [
	| nodes |
	
	nodes := self parent elements 
		select: [ :each | (each kind = self kind) and: [ each basename = self basename ] ].
	
	"this is the regular case"
	nodes size = 1 
		ifTrue: [ ^ aString ].
	
	"I need to dissambiguate"
	^ String streamContents: [ :stream |
		stream << aString << '_' <<  (nodes indexOf: self) asString ]
]

{ #category : 'initialization' }
IGTFunction >> fillFunctionWith: aCursor [

	returnTypeName := aCursor type resultType spelling.
	spelling := aCursor spelling.
	comment := aCursor rawComment.
	parameters := aCursor arguments collect: [ :each | 
		(IGParameter fromCursor: each)
			parent: self;
			yourself ]
]

{ #category : 'testing' }
IGTFunction >> isOperator [

	^ (self name beginsWith: 'operator') 
		and: [ self name size > 8 
		and: [ (self name at: 9) isAlphaNumeric not ] ]
]

{ #category : 'testing' }
IGTFunction >> isReturnTypeVoid [

	^ self returnTypeName = 'void'
]

{ #category : 'accessing' }
IGTFunction >> parameters [

	^ parameters
]

{ #category : 'accessing' }
IGTFunction >> parametersAsList [

	^ (self parameters collect: [ :each | each asParameterString ]) asCommaString
]

{ #category : 'handling' }
IGTFunction >> resolveReturnType [

	self isReturnTypeVoid ifTrue: [ ^ nil ].
	
	^ IGType new
		parent: self;
		name: self returnTypeName;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
IGTFunction >> returnTypeName [

	^ returnTypeName
]

{ #category : 'accessing' }
IGTFunction >> spelling [

	^ spelling
]
