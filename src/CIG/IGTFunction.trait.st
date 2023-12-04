Trait {
	#name : 'IGTFunction',
	#instVars : [
		'returnTypeName',
		'spelling',
		'comment'
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

{ #category : 'initialization' }
IGTFunction >> fillFunctionWith: aCursor [

	returnTypeName := aCursor type resultType spelling.
	spelling := aCursor spelling.
	comment := aCursor rawComment
]

{ #category : 'testing' }
IGTFunction >> isReturnTypeVoid [

	^ self returnTypeName = 'void'
]

{ #category : 'accessing' }
IGTFunction >> parameters [

	^ self elements select: [ :each | each kind = IGParameter kind ]
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
