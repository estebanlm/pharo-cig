Class {
	#name : 'IGFunction',
	#superclass : 'IGElement',
	#instVars : [
		'spelling',
		'parameters',
		'returnTypeName'
	],
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
IGFunction >> addParameter: aParameter [

	aParameter parent: self.
	parameters add: aParameter
]

{ #category : 'accessing' }
IGFunction >> argumentsAsList [

	^ (self parameters collect: [ :each | each asArgumentString ]) asCommaString
]

{ #category : 'accessing' }
IGFunction >> asFunctionDeclarationWithPrefix: prefix [ 

	^ String streamContents: [ :stream | 
		stream 
			<< self returnTypeName << ' '
			<< prefix << self spelling 
			<< '(' << self parametersAsList << ')' ]
]

{ #category : 'initialization' }
IGFunction >> fromCursor: aCursor [

	super fromCursor: aCursor.
	returnTypeName := aCursor type resultType spelling.
	spelling := aCursor spelling.
]

{ #category : 'initialization' }
IGFunction >> initialize [
	
	super initialize.
	parameters := OrderedCollection new
]

{ #category : 'testing' }
IGFunction >> isReturnTypeVoid [

	^ self returnTypeName = 'void'
]

{ #category : 'accessing' }
IGFunction >> parameters [

	^ parameters
]

{ #category : 'accessing' }
IGFunction >> parametersAsList [

	^ (self parameters collect: [ :each | each asParameterString ]) asCommaString
]

{ #category : 'accessing' }
IGFunction >> returnTypeName [

	^ returnTypeName
]

{ #category : 'accessing' }
IGFunction >> spelling [

	^ spelling
]
