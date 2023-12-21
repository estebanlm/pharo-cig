Class {
	#name : 'IGCConstructorOverloadedNewTemplate',
	#superclass : 'IGCConstructorTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCConstructorOverloadedNewTemplate class >> handlesElement: anElement [

	^ anElement isClassMember 
		and: [ anElement isConstructor
		and: [ anElement parent hasOperatorOverloadNew ] ]
]

{ #category : 'private' }
IGCConstructorOverloadedNewTemplate >> basicGenerateBody [

	^ 'new ({operatorArguments}) {func}({arguments})'
		format: {
			#operatorArguments -> self operatorArguments.
			#func -> self element cppDeclaration.
			#arguments -> self generateArguments.
		} asDictionary
]

{ #category : 'generating' }
IGCConstructorOverloadedNewTemplate >> generateArguments [
		
	^ String streamContents: [ :stream |
		(self parameters allButFirst: self operatorNew parameters size - 1)
			do: [ :each | stream << each generateArgument ]
			separatedBy: [ stream << ', ' ] ]
]

{ #category : 'generating' }
IGCConstructorOverloadedNewTemplate >> operatorArguments [
		
	^ String streamContents: [ :stream |
		(self parameters first: self operatorNew parameters size - 1)
			do: [ :each | stream << each generateArgument ]
			separatedBy: [ stream << ', ' ] ]
]

{ #category : 'accessing' }
IGCConstructorOverloadedNewTemplate >> operatorNew [
		
	^ self element parent operatorNew
]

{ #category : 'accessing' }
IGCConstructorOverloadedNewTemplate >> parameters [
	
	^ parameters ifNil: [ 
		parameters := (self operatorNew parameters allButFirst, self element parameters)
			collect: [ :each | IGCParameterTemplate forParameter: each ] ]
]
