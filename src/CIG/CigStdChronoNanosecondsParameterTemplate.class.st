"
A special template to handle std::string type translation.
"
Class {
	#name : 'CigStdChronoNanosecondsParameterTemplate',
	#superclass : 'CigCParameterTemplate',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'private' }
CigStdChronoNanosecondsParameterTemplate class >> handlesType: aType [

	^ aType parseType name = #'std::chrono::nanoseconds'
]

{ #category : 'generating' }
CigStdChronoNanosecondsParameterTemplate >> castReturn: aString [ 

	^ String streamContents: [ :stream |
		stream << 'auto _tmp = ' << aString << ';'; cr.
		stream << 'auto _result = _tmp.count();'; cr.
		stream << 'return (int64)_result' ]
]

{ #category : 'generating' }
CigStdChronoNanosecondsParameterTemplate >> generateArgument [
	
	^ String streamContents: [ :stream | 
		stream << 'std::chrono::nanoseconds(' << self name << ')' ]
]

{ #category : 'generating' }
CigStdChronoNanosecondsParameterTemplate >> generateCType [
	
	^ 'int64'
]
