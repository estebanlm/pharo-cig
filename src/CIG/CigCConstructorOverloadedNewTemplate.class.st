Class {
	#name : 'CigCConstructorOverloadedNewTemplate',
	#superclass : 'CigCConstructorTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCConstructorOverloadedNewTemplate class >> handlesElement: anElement [

	^ anElement isClassMember 
		and: [ anElement isConstructor
		and: [ anElement parent hasOperatorOverloadNewManyArguments ] ]
]

{ #category : 'private' }
CigCConstructorOverloadedNewTemplate >> basicGenerateBody [

	^ 'new ({operatorArguments}) {func}({arguments})'
		format: {
			#operatorArguments -> self operatorArguments.
			#func -> self element cppDeclaration.
			#arguments -> self generateArguments.
		} asDictionary
]

{ #category : 'generating' }
CigCConstructorOverloadedNewTemplate >> generateArguments [
		
	^ String streamContents: [ :stream |
		(self parameters allButFirst: self operatorNew parameters size - 1)
			do: [ :each | stream << each generateArgument ]
			separatedBy: [ stream << ', ' ] ]
]

{ #category : 'generating' }
CigCConstructorOverloadedNewTemplate >> operatorArguments [
		
	^ String streamContents: [ :stream |
		(self parameters first: self operatorNew parameters size - 1)
			do: [ :each | stream << each generateArgument ]
			separatedBy: [ stream << ', ' ] ]
]

{ #category : 'accessing' }
CigCConstructorOverloadedNewTemplate >> operatorNew [
		
	^ self element parent operatorNew
]

{ #category : 'accessing' }
CigCConstructorOverloadedNewTemplate >> parameters [
	
	^ parameters ifNil: [ 
		parameters := (self operatorNew parameters allButFirst, self element parameters)
			collect: [ :each | CigCParameterTemplate forParameter: each ] ]
]
