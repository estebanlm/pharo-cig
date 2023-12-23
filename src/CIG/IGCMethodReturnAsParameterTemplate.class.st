Class {
	#name : 'IGCMethodReturnAsParameterTemplate',
	#superclass : 'IGCInstanceMethodTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCMethodReturnAsParameterTemplate class >> handlesElement: anElement [
	| type |

	type := anElement resolveReturnType.
	^ type isClass and: [ type element hasOperatorOverloadNewManyArguments ]
]

{ #category : 'generating' }
IGCMethodReturnAsParameterTemplate >> castReturn: aString [
	| cppDecl |

	cppDecl := self returnArgument type element cppDeclaration.
	^ String streamContents: [ :stream | 
		stream << '*(' << cppDecl << '*)'. 
		stream << 'result = '.
		stream << aString ]
]

{ #category : 'generating' }
IGCMethodReturnAsParameterTemplate >> generateArguments [

	^ String streamContents: [ :stream |
		self parameters allButLast
			do: [ :each | stream << each generateArgument ]
			separatedBy: [ stream << ', ' ] ]	
]

{ #category : 'accessing' }
IGCMethodReturnAsParameterTemplate >> generateHeader [

	^ 'void {func}({parameters})'
		format: {
			#func -> self element cDeclaration.
			#parameters -> self generateParameters 
		} asDictionary
]

{ #category : 'accessing' }
IGCMethodReturnAsParameterTemplate >> parameters [
	
	^ parameters ifNil: [ 
		parameters := super parameters copyWith: self returnArgument ]
]

{ #category : 'private' }
IGCMethodReturnAsParameterTemplate >> returnArgument [
	
	^ IGCParameterReturnAsParameterTemplate forElement: self element
]
