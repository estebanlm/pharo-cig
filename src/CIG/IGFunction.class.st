Class {
	#name : 'IGFunction',
	#superclass : 'IGElement',
	#traits : 'IGTFunction',
	#classTraits : 'IGTFunction classTrait',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGFunction class >> kind [

	^ CXCursor_FunctionDecl
]

{ #category : 'visiting' }
IGFunction >> accept: aVisitor [

	aVisitor visitFunction: self
]

{ #category : 'accessing' }
IGFunction >> argumentsAsList [

	^ (self parameters collect: [ :each | each asArgumentString ]) asCommaString
]

{ #category : 'private' }
IGFunction >> buildParameters: aCollection on: stream [ 
	
	aCollection ifEmpty: [ ^ self ].
	
	aCollection first in: [ :each | 
		aCollection size > 1 
			ifTrue: [ stream << each name capitalized ].
		stream << ': ' << each name << ' ' ].
	aCollection allButFirst do: [ :each | 
		stream << each name << ': ' << each name << ' ' ]
]

{ #category : 'initialization' }
IGFunction >> fromCursor: aCursor [

	super fromCursor: aCursor.
	self fillFunctionWith: aCursor
]

{ #category : 'testing' }
IGFunction >> isFunction [

	^ true
]

{ #category : 'testing' }
IGFunction >> isOperator [

	^ (self name beginsWith: 'operator') and: [
		  self name size > 8 and: [ (self name at: 9) isAlphaNumeric not ] ]
]

{ #category : 'testing' }
IGFunction >> isReturnTypeVoid [

	^ self returnTypeName = 'void'
]

{ #category : 'accessing' }
IGFunction >> parameters [

	^ self elements select: [ :each | each kind = IGParameter kind ]
]

{ #category : 'accessing' }
IGFunction >> parametersAsList [

	^ (self parameters collect: [ :each | each asParameterString ]) asCommaString
]

{ #category : 'accessing' }
IGFunction >> pathName [

	^ self spelling
]

{ #category : 'accessing' }
IGFunction >> phDeclaration [

	^ (String streamContents: [ :stream | 
			stream  << self spelling uncapitalized.
			self buildParameters: self parameters on: stream ])
		trimmed
]

{ #category : 'handling' }
IGFunction >> resolveReturnType [

	self isReturnTypeVoid ifTrue: [ ^ nil ].
	
	^ IGType new
		parent: self;
		name: self returnTypeName;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
IGFunction >> returnTypeName [

	^ returnTypeName
]

{ #category : 'accessing' }
IGFunction >> spelling [

	^ spelling
]
