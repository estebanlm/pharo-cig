"
A special template to handle `std::complex` type translation.
"
Class {
	#name : 'CigStdComplexParameterTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'private' }
CigStdComplexParameterTemplate class >> handlesType: aType [

	^ aType isType: 'std::complex'
]

{ #category : 'generating' }
CigStdComplexParameterTemplate >> castReturn: aString [ 

	^ String streamContents: [ :stream |
		stream << 'auto _tmp = ' << aString << ';'; cr.
		stream << 'auto _result = std::make_unique<std::complex<' << self templateTypeName << '>>(_tmp);'; cr.
		stream << 'return (void*)_result.release()' ]
]

{ #category : 'generating' }
CigStdComplexParameterTemplate >> generateArgument [
	
	^ '*(std::vector<{type}>*)std::memcpy((new std::complex<{type}>()).data(), {name}, {name}->size())' 
		format: {
			#type -> self templateTypeName.
			#name -> self element name.
		} 
		asDictionary
]

{ #category : 'generating' }
CigStdComplexParameterTemplate >> generateCType [
	
	^ 'void*'
]

{ #category : 'private' }
CigStdComplexParameterTemplate >> templateTypeName [
	| typeName |

	typeName := self type parseType templateName.
	^ (self type parent scopeLookup: typeName)
		ifNotNil: [ :anElement | anElement cppDeclaration ]
		ifNil: [ typeName ]
]
