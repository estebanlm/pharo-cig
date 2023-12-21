Class {
	#name : 'IGCFunctionReturnAsParameterTemplate',
	#superclass : 'IGCFunctionTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCFunctionReturnAsParameterTemplate class >> handlesElement: anElement [
	| type |

	type := anElement resolveReturnType.
	^ type isClass and: [ type element hasOperatorOverloadNew ]
]

{ #category : 'generating' }
IGCFunctionReturnAsParameterTemplate >> castReturn: aString [
	| cppDecl |

	cppDecl := self returnArgument type element cppDeclaration.
	^ String streamContents: [ :stream | 
		stream << '*(' << cppDecl << '*)'. 
		stream << 'result = '.
		stream << aString ]
]

{ #category : 'generating' }
IGCFunctionReturnAsParameterTemplate >> generateArguments [

	^ String streamContents: [ :stream |
		self parameters allButLast
			do: [ :each | stream << each generateArgument ]
			separatedBy: [ stream << ', ' ] ]	
]

{ #category : 'accessing' }
IGCFunctionReturnAsParameterTemplate >> generateHeader [

	^ 'void {func}({parameters})'
		format: {
			#func -> self element cDeclaration.
			#parameters -> self generateParameters 
		} asDictionary
]

{ #category : 'accessing' }
IGCFunctionReturnAsParameterTemplate >> parameters [
	
	^ parameters ifNil: [ 
		parameters := super parameters copyWith: self returnArgument ]
]

{ #category : 'private' }
IGCFunctionReturnAsParameterTemplate >> returnArgument [
	
	^ IGCParameterReturnAsParameterTemplate forElement: self element
]
