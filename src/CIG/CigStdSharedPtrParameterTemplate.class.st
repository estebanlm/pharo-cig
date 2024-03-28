"
A special template to handle std::shared_ptr type translation.
"
Class {
	#name : 'CigStdSharedPtrParameterTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'private' }
CigStdSharedPtrParameterTemplate class >> handlesType: aType [

	^ aType isType: 'std::shared_ptr'
]

{ #category : 'generating' }
CigStdSharedPtrParameterTemplate >> castReturn: aString [ 

	^ String streamContents: [ :stream |
		stream << 'auto _tmp = ' << aString << ';'; cr.
		stream << 'auto _result = _tmp.get();'; cr.
		stream << 'return (' << self typeName << '*)_result' ]
]

{ #category : 'generating' }
CigStdSharedPtrParameterTemplate >> generateArgument [
	
	^ String streamContents: [ :stream | 
		stream << 'std::shared_ptr<' << self typeName << '>(' << self name << ')' ]
]

{ #category : 'generating' }
CigStdSharedPtrParameterTemplate >> generateCType [
	
	^ 'void*'
]

{ #category : 'accessing' }
CigStdSharedPtrParameterTemplate >> typeName [
	
	^ self type parseType templateName
]
