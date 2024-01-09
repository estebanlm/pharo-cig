"
The std::array class element.
It is need to translate from std::array to void* and viceversa.
"
Class {
	#name : 'CigStdArrayElement',
	#superclass : 'CigElement',
	#classTraits : '{} + TraitedClass',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'accessing' }
CigStdArrayElement class >> kind [
	
	^ nil
]

{ #category : 'visiting' }
CigStdArrayElement >> accept: aVisitor [
	
]

{ #category : 'initialization' }
CigStdArrayElement >> initialize [

	super initialize.
	self name: 'array'
]
