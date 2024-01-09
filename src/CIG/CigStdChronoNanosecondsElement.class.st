"
The std::string class element.
It is need to translate from std::string to char* and viceversa.
"
Class {
	#name : 'CigStdChronoNanosecondsElement',
	#superclass : 'CigElement',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'accessing' }
CigStdChronoNanosecondsElement class >> kind [
	
	^ nil
]

{ #category : 'visiting' }
CigStdChronoNanosecondsElement >> accept: aVisitor [
	
]

{ #category : 'initialization' }
CigStdChronoNanosecondsElement >> initialize [

	super initialize.
	self name: 'nanoseconds'
]
