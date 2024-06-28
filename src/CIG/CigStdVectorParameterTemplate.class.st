"
A special template to handle std::string type translation.
"
Class {
	#name : 'CigStdVectorParameterTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'private' }
CigStdVectorParameterTemplate class >> handlesType: aType [

	^ aType isType: 'std::vector'
]

{ #category : 'generating' }
CigStdVectorParameterTemplate >> castReturn: aString [ 

	^ String streamContents: [ :stream |
		stream << 'auto _tmp = ' << aString << ';'; cr.
		stream << 'auto _result = _tmp.data();'; cr.
		stream << 'return (void*)_result' ]
]

{ #category : 'generating' }
CigStdVectorParameterTemplate >> generateArgument [
	
	^ '*(std::vector<{type}>*)std::memcpy((new std::vector<{type}>).data(), {name}, {name}.size)' 
		format: {
			#type -> self templateTypeName.
			#name -> self element name.
		} 
		asDictionary
]

{ #category : 'generating' }
CigStdVectorParameterTemplate >> generateCType [
	
	^ 'void*'
]

{ #category : 'private' }
CigStdVectorParameterTemplate >> templateTypeName [
	| typeName |

	typeName := self type parseType templateName.
	^ (self type parent scopeLookup: typeName)
		ifNotNil: [ :anElement | anElement cppDeclaration ]
		ifNil: [ typeName ]
]
