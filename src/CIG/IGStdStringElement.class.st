Class {
	#name : 'IGStdStringElement',
	#superclass : 'IGElement',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'accessing' }
IGStdStringElement class >> kind [
	
	^ nil
]

{ #category : 'visiting' }
IGStdStringElement >> accept: aVisitor [
	
]

{ #category : 'initialization' }
IGStdStringElement >> initialize [

	super initialize.
	self name: 'string'
]
