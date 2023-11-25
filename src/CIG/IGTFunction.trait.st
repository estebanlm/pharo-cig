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

{ #category : 'converting' }
IGTFunction >> asFunctionDeclarationWithPrefix: prefix delimiter: delim [

	^ String streamContents: [ :stream |
		  stream 
			<< self returnTypeName << ' ' << prefix << delim
		 	 << self spelling << '(' << self parametersAsList << ')' ]
]

{ #category : 'converting' }
IGTFunction >> asFunctionSourceWithPrefix: prefix delimiter: delim [

	^ '{1} \{
	{5}{2}::{3}({4});
\}' format: {
			  (self asFunctionDeclarationWithPrefix: prefix delimiter: delim).
			  prefix.
			  self spelling.
			  self argumentsAsList.
			  (self isReturnTypeVoid
				   ifTrue: [ '' ]
				   ifFalse: [ 'return ' ]) }
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

{ #category : 'accessing' }
IGTFunction >> returnTypeName [

	^ returnTypeName
]

{ #category : 'accessing' }
IGTFunction >> spelling [

	^ spelling
]
