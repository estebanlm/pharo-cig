Class {
	#name : 'CigCBaseFunctionTemplate',
	#superclass : 'CigCTemplate',
	#instVars : [
		'parameters',
		'return'
	],
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCBaseFunctionTemplate >> basicGenerateBody [

	^ self subclassResponsibility
]

{ #category : 'generating' }
CigCBaseFunctionTemplate >> castReturn: aString [

	self element isReturnTypeVoid ifTrue: [ ^ aString ].
	^ self return castReturn: aString
]

{ #category : 'generating' }
CigCBaseFunctionTemplate >> generate [

	^ '{header} \{
{body}
}' format: {
		#header -> self generateHeader.
		#body -> (self indent: self generateBody).
	} asDictionary
]

{ #category : 'generating' }
CigCBaseFunctionTemplate >> generateArguments [
		
	^ String streamContents: [ :stream |
		self parameters 
			do: [ :each | stream << each generateArgument ]
			separatedBy: [ stream << ', ' ] ]
]

{ #category : 'generating' }
CigCBaseFunctionTemplate >> generateBody [
	
	^ String streamContents: [ :stream |
		stream << (self castReturn: self basicGenerateBody).
		stream << ';' ]
]

{ #category : 'generating' }
CigCBaseFunctionTemplate >> generateHeader [

	^ '{type} {func}({parameters})'
		format: {
			#type -> self generateReturnType.
			#func -> self element cDeclaration.
			#parameters -> self generateParameters 
		} asDictionary
]

{ #category : 'generating' }
CigCBaseFunctionTemplate >> generateParameters [
	
	^ String streamContents: [ :stream |
		self parameters 
			do: [ :each | stream << each generate ]
			separatedBy: [ stream << ', ' ] ]
]

{ #category : 'generating' }
CigCBaseFunctionTemplate >> generateReturnType [

	^ self return generateCType
]

{ #category : 'accessing' }
CigCBaseFunctionTemplate >> indent: aString [ 
	
	^ String streamContents: [ :stream |
		 aString lines 
			do: [ :each | 
				stream tab.
				stream << each ]
			separatedBy: [ stream cr ] ]
]

{ #category : 'accessing' }
CigCBaseFunctionTemplate >> parameters [
	
	^ parameters ifNil: [ 
		parameters := self element parameters 
			collect: [ :each | CigCParameterTemplate forParameter: each ] ]
]

{ #category : 'accessing' }
CigCBaseFunctionTemplate >> return [

	^ return ifNil: [ return := CigCParameterTemplate forReturn: self element ]
]
