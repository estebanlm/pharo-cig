Trait {
	#name : 'IGTFunction',
	#instVars : [
		'returnTypeName',
		'spelling'
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

{ #category : 'initialization' }
IGTFunction >> fillFunctionWith: aCursor [

	returnTypeName := aCursor type resultType spelling.
	spelling := aCursor spelling
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
		reference: self typeReference;
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

{ #category : 'handling' }
IGTFunction >> typeReference [
	"if isLValueReference = true, there will be a type reference"

	^ self elements 
		detect: [ :each | each isTypeReference ]
		ifNone: [ nil ]
]
