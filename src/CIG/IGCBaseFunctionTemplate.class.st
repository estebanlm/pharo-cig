Class {
	#name : 'IGCBaseFunctionTemplate',
	#superclass : 'IGCTemplate',
	#instVars : [
		'parameters',
		'return'
	],
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCBaseFunctionTemplate >> basicGenerateBody [

	^ self subclassResponsibility
]

{ #category : 'generating' }
IGCBaseFunctionTemplate >> castReturn: aString [

	self element isReturnTypeVoid ifTrue: [ ^ aString ].
	^ self return castReturn: aString
]

{ #category : 'generating' }
IGCBaseFunctionTemplate >> generate [

	^ '{header} \{
{body}
}' format: {
		#header -> self generateHeader.
		#body -> (self indent: self generateBody).
	} asDictionary
]

{ #category : 'generating' }
IGCBaseFunctionTemplate >> generateArguments [
		
	^ String streamContents: [ :stream |
		self parameters 
			do: [ :each | stream << each generateArgument ]
			separatedBy: [ stream << ', ' ] ]
]

{ #category : 'generating' }
IGCBaseFunctionTemplate >> generateBody [
	
	^ String streamContents: [ :stream |
		stream << (self castReturn: self basicGenerateBody).
		stream << ';' ]
]

{ #category : 'generating' }
IGCBaseFunctionTemplate >> generateHeader [

	^ '{type} {func}({parameters})'
		format: {
			#type -> self generateReturnType.
			#func -> self element cDeclaration.
			#parameters -> self generateParameters 
		} asDictionary
]

{ #category : 'generating' }
IGCBaseFunctionTemplate >> generateParameters [
	
	^ String streamContents: [ :stream |
		self parameters 
			do: [ :each | stream << each generate ]
			separatedBy: [ stream << ', ' ] ]
]

{ #category : 'generating' }
IGCBaseFunctionTemplate >> generateReturnType [

	^ self return generateCType
]

{ #category : 'accessing' }
IGCBaseFunctionTemplate >> indent: aString [ 
	
	^ String streamContents: [ :stream |
		 aString lines 
			do: [ :each | 
				stream tab.
				stream << each ]
			separatedBy: [ stream cr ] ]
]

{ #category : 'accessing' }
IGCBaseFunctionTemplate >> parameters [
	
	^ parameters ifNil: [ 
		parameters := self element parameters 
			collect: [ :each | IGCParameterTemplate forParameter: each ] ]
]

{ #category : 'accessing' }
IGCBaseFunctionTemplate >> return [

	^ return ifNil: [ return := IGCParameterTemplate forReturn: self element ]
]
