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
		stream << 'auto _tmp = ' << aString << ';'; cr.
		stream << 'auto _result = _tmp.c_str();'; cr.
		stream << 'return (char*)_result' ]
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
