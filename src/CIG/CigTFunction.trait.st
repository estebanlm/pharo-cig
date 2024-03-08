Trait {
	#name : 'CigTFunction',
	#instVars : [
		'returnTypeName',
		'spelling',
		'comment',
		'parameters',
		'isVariadic'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'private' }
CigTFunction >> buildParameters: aCollection on: stream [ 
	
	aCollection ifEmpty: [ ^ self ].
	
	aCollection first in: [ :each | 
		"if I have more than one argument, and the first argument name will be 
		 different of the end of the function name, I add it as part of the name
		 otherwise, just skeep it"
		((aCollection size > 1) 
			and: [ (each nameMatchesLastOf: stream contents) not ])
			ifTrue: [ stream << each name capitalized ].
		stream << ': ' << each name << ' ' ].
	aCollection allButFirst do: [ :each | 
		stream << each name << ': ' << each name << ' ' ]
]

{ #category : 'accessing' }
CigTFunction >> comment [

	^ comment	
]

{ #category : 'private' }
CigTFunction >> disambiguate: aString [
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

{ #category : 'private' }
CigTFunction >> disambiguate: aString arguments: aCollection [ 
	| nodes |
	
	nodes := self parent elements 
		select: [ :each | 
			(each kind = self kind) 
			and: [ each basename = self basename
			and: [ each parameters size = aCollection size ] ] ].
	
	"this is the regular case"
	nodes size = 1 
		ifTrue: [ ^ aString ].
	
	"I need to dissambiguate"
	^ String streamContents: [ :stream |
		stream << aString << '_' <<  (nodes indexOf: self) asString ]
]

{ #category : 'initialization' }
CigTFunction >> fillFunctionWith: aCursor [

	returnTypeName := aCursor type resultType spelling.
	spelling := aCursor spelling.
	comment := aCursor rawComment.
	isVariadic := aCursor isVariadic.
	parameters := aCursor arguments collect: [ :each | 
		(CigParameter fromCursor: each)
			parent: self;
			yourself ]
]

{ #category : 'testing' }
CigTFunction >> hasVariadicListArgument [

	^ self parameters anySatisfy: [ :each | each typeName = 'va_list' ]
]

{ #category : 'testing' }
CigTFunction >> isOperator [

	^ (self name beginsWith: 'operator') 
		and: [ self name size > 8 
		and: [ (self name at: 9) isAlphaNumeric not ] ]
]

{ #category : 'testing' }
CigTFunction >> isReturnTypeVoid [

	^ self returnTypeName = 'void'
]

{ #category : 'testing' }
CigTFunction >> isVariadic [

	^ isVariadic
]

{ #category : 'accessing' }
CigTFunction >> parameters [

	^ parameters
]

{ #category : 'handling' }
CigTFunction >> resolveReturnType [

	^ CigType new
		parent: self;
		name: self returnTypeName;
		typeReference: self typeReference;
		yourself
]

{ #category : 'accessing' }
CigTFunction >> returnTypeName [

	^ returnTypeName
]

{ #category : 'accessing' }
CigTFunction >> spelling [

	^ spelling
]
