"
A special template to handle std::string type translation.
"
Class {
	#name : 'CigStdStringParameterTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'private' }
CigStdStringParameterTemplate class >> handlesType: aType [

	^ aType parseType name = #'std::string'
]

{ #category : 'generating' }
CigStdStringParameterTemplate >> castReturn: aString [ 

	^ String streamContents: [ :stream |
		stream << 'auto _tmp = ' << aString << ';'; cr.
		stream << 'auto _result = _tmp.c_str();'; cr.
		stream << 'return (char*)_result' ]
]

{ #category : 'generating' }
CigStdStringParameterTemplate >> generateArgument [
	
	^ String streamContents: [ :stream | 
		stream << 'std::string(' << self name << ')' ]
]

{ #category : 'generating' }
CigStdStringParameterTemplate >> generateCType [
	
	^ 'char*'
]
