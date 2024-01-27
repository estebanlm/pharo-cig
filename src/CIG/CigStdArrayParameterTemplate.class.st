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
	
	^ '*(std::array<{type}, {size}>*)std::memcpy((new std::array<{type}, {size}>).data(), {name}, {size})' 
		format: {
			#type -> self templateTypeName.
			#name -> self element name.
			#size -> self templateSize.
		} 
		asDictionary
]

{ #category : 'generating' }
CigStdArrayParameterTemplate >> generateCType [
	
	^ 'void*'
]

{ #category : 'private' }
CigStdArrayParameterTemplate >> templateSize [

	^ (self type parseType templateName substrings: ', ') second
]

{ #category : 'private' }
CigStdArrayParameterTemplate >> templateTypeName [
	| typeName |

	typeName := (self type parseType templateName substrings: ', ') first.
	^ (self type parent scopeLookup: typeName)
		ifNotNil: [ :anElement | anElement cppDeclaration ]
		ifNil: [ typeName ]
]
