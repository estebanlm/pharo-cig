"
This is the std:: C++ namespace, from which we just want what we need to translet from/to C++.

"
Class {
	#name : 'CigStdChronoNamespace',
	#superclass : 'CigElement',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'accessing' }
CigStdChronoNamespace class >> elementName [
	
	^ 'chrono'
]

{ #category : 'accessing' }
CigStdChronoNamespace class >> kind [
	
	^ nil
]

{ #category : 'visiting' }
CigStdChronoNamespace >> accept: aVisitor [

]

{ #category : 'initialization' }
CigStdChronoNamespace >> initialize [

	super initialize.
	self name: self class elementName.
	self addElement: CigStdChronoNanosecondsElement new
]
