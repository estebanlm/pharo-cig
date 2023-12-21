Class {
	#name : 'IGCDisposeMethodTemplate',
	#superclass : 'IGCBaseFunctionTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCDisposeMethodTemplate >> basicGenerateBody [

	^ 'delete {self}'
		format: {
			#self -> self generateSelf.
		} asDictionary
]

{ #category : 'generating' }
IGCDisposeMethodTemplate >> castReturn: aString [

	^ aString
]

{ #category : 'generating' }
IGCDisposeMethodTemplate >> generateHeader [

	^ 'void {class}_{func}({parameters})'
		format: {
			#class -> self element fullName.
			#func -> self name.
			#parameters -> self generateParameters 
		} asDictionary
]

{ #category : 'generating' }
IGCDisposeMethodTemplate >> generateParameters [
	
	^ self selfTemplate generate
]

{ #category : 'generating' }
IGCDisposeMethodTemplate >> generateSelf [
		
	^ self selfTemplate generateCast
]

{ #category : 'generating' }
IGCDisposeMethodTemplate >> name [
		
	^ 'dispose'
]

{ #category : 'private' }
IGCDisposeMethodTemplate >> selfTemplate [

	^ IGCParameterSelfTemplate for: self element
]
