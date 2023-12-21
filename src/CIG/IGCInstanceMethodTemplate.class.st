Class {
	#name : 'IGCInstanceMethodTemplate',
	#superclass : 'IGCMethodTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCInstanceMethodTemplate >> basicGenerateBody [

	^ '{self}->{func}({arguments})'
		format: {
			#self -> self generateSelf.
			#func -> self element spelling.
			#arguments -> self generateArguments.
		} asDictionary
]

{ #category : 'generating' }
IGCInstanceMethodTemplate >> generateParameters [
	
	^ String streamContents: [ :stream |
		({ self selfTemplate }, self parameters)
			do: [ :each | stream << each generate ]
			separatedBy: [ stream << ', ' ] ]
]

{ #category : 'generating' }
IGCInstanceMethodTemplate >> generateSelf [
		
	^ String streamContents: [ :stream |
		stream << '(' << self selfTemplate generateCast << ')' ]
]

{ #category : 'private' }
IGCInstanceMethodTemplate >> selfTemplate [

	^ IGCParameterSelfTemplate for: self element parent
]
