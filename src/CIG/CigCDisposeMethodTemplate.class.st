Class {
	#name : 'CigCDisposeMethodTemplate',
	#superclass : 'CigCBaseFunctionTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCDisposeMethodTemplate >> basicGenerateBody [

	^ 'delete {self}'
		format: {
			#self -> self generateSelf.
		} asDictionary
]

{ #category : 'generating' }
CigCDisposeMethodTemplate >> castReturn: aString [

	^ aString
]

{ #category : 'generating' }
CigCDisposeMethodTemplate >> generateHeader [

	^ 'void {class}_{func}({parameters})'
		format: {
			#class -> self element fullName.
			#func -> self name.
			#parameters -> self generateParameters 
		} asDictionary
]

{ #category : 'generating' }
CigCDisposeMethodTemplate >> generateParameters [
	
	^ self selfTemplate generate
]

{ #category : 'generating' }
CigCDisposeMethodTemplate >> generateSelf [
		
	^ self selfTemplate generateCast
]

{ #category : 'generating' }
CigCDisposeMethodTemplate >> name [
		
	^ 'dispose'
]

{ #category : 'private' }
CigCDisposeMethodTemplate >> selfTemplate [

	^ CigCParameterSelfTemplate for: self element
]
