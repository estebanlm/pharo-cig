"
A special template to handle std::string type translation.
"
Class {
	#name : 'CigStdWStringParameterTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'private' }
CigStdWStringParameterTemplate class >> handlesType: aType [

	^ aType parseType name = #'std::wstring'
]

{ #category : 'generating' }
CigStdWStringParameterTemplate >> castReturn: aString [ 

	^ String streamContents: [ :stream |
		stream << 'auto _tmp = ' << aString << ';'; cr.
		stream << 'auto _result = _tmp.c_str();'; cr.
		stream << 'return (wchar_t*)_result' ]
]

{ #category : 'generating' }
CigStdWStringParameterTemplate >> generateArgument [
	
	^ String streamContents: [ :stream | 
		stream << 'std::wstring(' << self name << ')' ]
]

{ #category : 'generating' }
CigStdWStringParameterTemplate >> generateCType [
	
	^ 'wchar_t*'
]
