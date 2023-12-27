Class {
	#name : 'IGStdStringParameterTemplate',
	#superclass : 'IGCParameterTemplate',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'private' }
IGStdStringParameterTemplate class >> handlesType: aType [

	^ aType parseType name = #'std::string'
]

{ #category : 'generating' }
IGStdStringParameterTemplate >> castReturn: aString [ 

	^ String streamContents: [ :stream |
		stream << 'return (char*)(' << aString << ').c_str()' ]
]

{ #category : 'generating' }
IGStdStringParameterTemplate >> generateArgument [
	
	^ String streamContents: [ :stream | 
		stream << 'std::string(' << self name << ')' ]
]

{ #category : 'generating' }
IGStdStringParameterTemplate >> generateCType [
	
	^ 'char*'
]
