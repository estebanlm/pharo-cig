Class {
	#name : 'IGStdNamespace',
	#superclass : 'IGSpecialElement',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'accessing' }
IGStdNamespace class >> elementName [
	
	^ 'std'
]

{ #category : 'initialization' }
IGStdNamespace >> initialize [

	super initialize.
	self addElement: IGStdStringElement new
]
