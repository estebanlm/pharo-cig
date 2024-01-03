Class {
	#name : 'CigStdNamespace',
	#superclass : 'CigSpecialElement',
	#category : 'CIG-Node-Special',
	#package : 'CIG',
	#tag : 'Node-Special'
}

{ #category : 'accessing' }
CigStdNamespace class >> elementName [
	
	^ 'std'
]

{ #category : 'initialization' }
CigStdNamespace >> initialize [

	super initialize.
	self addElement: CigStdStringElement new
]
