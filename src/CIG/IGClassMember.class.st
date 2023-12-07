Class {
	#name : 'IGClassMember',
	#superclass : 'IGElement',
	#traits : 'IGTFunction',
	#classTraits : 'IGTFunction classTrait',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGClassMember class >> kind [
	
	^ nil
]

{ #category : 'accessing' }
IGClassMember >> argumentsAsList [

	^ (self parameters collect: [ :each | each asArgumentString ]) asCommaString
]

{ #category : 'private' }
IGClassMember >> buildParameters: aCollection on: stream [ 
	
	aCollection ifEmpty: [ ^ self ].
	
	aCollection first in: [ :each | 
		aCollection size > 1 
			ifTrue: [ stream << each name capitalized ].
		stream << ': ' << each name << ' ' ].
	aCollection allButFirst do: [ :each | 
		stream << each name << ': ' << each name << ' ' ]
]

{ #category : 'private' }
IGClassMember >> disambiguate: aString [
	| methods |
	
	methods := self parent elements 
		select: [ :each | (each kind = self kind) and: [ each basename = self basename  ] ].
	
	"this is the regular case"
	methods size = 1 
		ifTrue: [ ^ aString ].
	
	"I need to dissambiguate"
	^ String streamContents: [ :stream |
		stream << aString << '_' <<  (methods indexOf: self) asString ]
]

{ #category : 'initialization' }
IGClassMember >> fromCursor: aCursor [

	super fromCursor: aCursor.
	self fillFunctionWith: aCursor
]

{ #category : 'testing' }
IGClassMember >> isClassMember [

	^ true
]

{ #category : 'testing' }
IGClassMember >> isOperator [

	^ (self name beginsWith: 'operator') and: [
		  self name size > 8 and: [ (self name at: 9) isAlphaNumeric not ] ]
]

{ #category : 'testing' }
IGClassMember >> isReturnTypeVoid [

	^ self returnTypeName = 'void'
]

{ #category : 'accessing' }
IGClassMember >> parameters [

	^ self elements select: [ :each | each kind = IGParameter kind ]
]

{ #category : 'accessing' }
IGClassMember >> parametersAsList [

	^ (self parameters collect: [ :each | each asParameterString ]) asCommaString
]

{ #category : 'accessing' }
IGClassMember >> pathName [

	^ self spelling
]

{ #category : 'handling' }
IGClassMember >> resolveReturnType [

	self isReturnTypeVoid ifTrue: [ ^ nil ].
	
	^ IGType new
		parent: self;
		name: self returnTypeName;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
IGClassMember >> returnTypeName [

	^ returnTypeName
]

{ #category : 'accessing' }
IGClassMember >> spelling [

	^ spelling
]
