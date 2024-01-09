"
A special template to handle std::string type translation.
"
Class {
	#name : 'CigStdArrayParameterTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'private' }
CigStdArrayParameterTemplate class >> handlesType: aType [

	^ aType parseType name = #'std::array'
]

{ #category : 'generating' }
CigStdArrayParameterTemplate >> castReturn: aString [ 

	^ String streamContents: [ :stream |
		stream << 'auto _tmp = ' << aString << ';'; cr.
		stream << 'auto _result = _tmp.data();'; cr.
		stream << 'return (void*)_result' ]
]

{ #category : 'generating' }
CigStdArrayParameterTemplate >> generateArgument [
	
	^ '*(std::array<{type}>*)std::memcpy((new std:array<{type}>).data(), {name}, {size})' 
		format: {
			#type -> self type parseType templateName.
			#name -> self element name.
			#size -> (self type parseType templateName substrings: ', ') second.
		} 
		asDictionary
]

{ #category : 'generating' }
CigStdArrayParameterTemplate >> generateCType [
	
	^ 'void*'
]
