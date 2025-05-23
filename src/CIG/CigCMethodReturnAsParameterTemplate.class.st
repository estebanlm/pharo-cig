Class {
	#name : 'CigCMethodReturnAsParameterTemplate',
	#superclass : 'CigCInstanceMethodTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCMethodReturnAsParameterTemplate class >> handlesElement: anElement [

	^ anElement exposesReturnValueAsParameter
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
CigCMethodReturnAsParameterTemplate >> generateHeaderForFFI [

	^ 'void {func}({parameters})'
		format: {
			#func -> self element cDeclaration.
			#parameters -> self generateParametersForFFI
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
