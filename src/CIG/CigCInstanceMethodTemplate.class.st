Class {
	#name : 'CigCInstanceMethodTemplate',
	#superclass : 'CigCMethodTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCInstanceMethodTemplate >> basicGenerateBody [

	^ '{self}->{func}({arguments})'
		format: {
			#self -> self generateSelf.
			#func -> self element spelling.
			#arguments -> self generateArguments.
		} asDictionary
]

{ #category : 'generating' }
CigCInstanceMethodTemplate >> generateParameters [
	
	^ String streamContents: [ :stream |
		({ self selfTemplate }, self parameters)
			do: [ :each | stream << each generate ]
			separatedBy: [ stream << ', ' ] ]
]

{ #category : 'generating' }
CigCInstanceMethodTemplate >> generateSelf [
		
	^ String streamContents: [ :stream |
		stream << '(' << self selfTemplate generateCast << ')' ]
]

{ #category : 'private' }
CigCInstanceMethodTemplate >> selfTemplate [

	^ CigCParameterSelfTemplate for: self element parent
]
