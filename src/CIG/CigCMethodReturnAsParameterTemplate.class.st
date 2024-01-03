Class {
	#name : 'CigCMethodReturnAsParameterTemplate',
	#superclass : 'CigCInstanceMethodTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCMethodReturnAsParameterTemplate class >> handlesElement: anElement [
	| type |

	type := anElement resolveReturnType.
	^ type isClass 
		and: [ type isPointer not
		and: [ type element hasOperatorOverloadNewManyArguments ] ]
]

{ #category : 'generating' }
CigCMethodReturnAsParameterTemplate >> castReturn: aString [
	| cppDecl |

	cppDecl := self returnArgument type element cppDeclaration.
	^ String streamContents: [ :stream | 
		stream << '*(' << cppDecl << '*)'. 
		stream << 'result = '.
		stream << aString ]
]

{ #category : 'generating' }
CigCMethodReturnAsParameterTemplate >> generateArguments [

	^ String streamContents: [ :stream |
		self parameters allButLast
			do: [ :each | stream << each generateArgument ]
			separatedBy: [ stream << ', ' ] ]	
]

{ #category : 'accessing' }
CigCMethodReturnAsParameterTemplate >> generateHeader [

	^ 'void {func}({parameters})'
		format: {
			#func -> self element cDeclaration.
			#parameters -> self generateParameters 
		} asDictionary
]

{ #category : 'accessing' }
CigCMethodReturnAsParameterTemplate >> parameters [
	
	^ parameters ifNil: [ 
		parameters := super parameters copyWith: self returnArgument ]
]

{ #category : 'private' }
CigCMethodReturnAsParameterTemplate >> returnArgument [
	
	^ CigCParameterReturnAsParameterTemplate forElement: self element
]
