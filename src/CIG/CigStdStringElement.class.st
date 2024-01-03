Class {
	#name : 'CigStdStringElement',
	#superclass : 'CigElement',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'accessing' }
CigStdStringElement class >> kind [
	
	^ nil
]

{ #category : 'visiting' }
CigStdStringElement >> accept: aVisitor [
	
]

{ #category : 'initialization' }
CigStdStringElement >> initialize [

	super initialize.
	self name: 'string'
]
