Class {
	#name : 'CigCFunctionReturnAsParameterTemplate',
	#superclass : 'CigCFunctionTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCFunctionReturnAsParameterTemplate class >> handlesElement: anElement [
	| type |

	type := anElement resolveReturnType.
	^ type isClass and: [ type element hasOperatorOverloadNewManyArguments ]
]

{ #category : 'generating' }
CigCFunctionReturnAsParameterTemplate >> castReturn: aString [
	| cppDecl |

	cppDecl := self returnArgument type element cppDeclaration.
	^ String streamContents: [ :stream | 
		stream << '*(' << cppDecl << '*)'. 
		stream << 'result = '.
		stream << aString ]
]

{ #category : 'generating' }
CigCFunctionReturnAsParameterTemplate >> generateArguments [

	^ String streamContents: [ :stream |
		self parameters allButLast
			do: [ :each | stream << each generateArgument ]
			separatedBy: [ stream << ', ' ] ]	
]

{ #category : 'accessing' }
CigCFunctionReturnAsParameterTemplate >> generateHeader [

	^ 'void {func}({parameters})'
		format: {
			#func -> self element cDeclaration.
			#parameters -> self generateParameters 
		} asDictionary
]

{ #category : 'accessing' }
CigCFunctionReturnAsParameterTemplate >> parameters [
	
	^ parameters ifNil: [ 
		parameters := super parameters copyWith: self returnArgument ]
]

{ #category : 'private' }
CigCFunctionReturnAsParameterTemplate >> returnArgument [
	
	^ CigCParameterReturnAsParameterTemplate forElement: self element
]
