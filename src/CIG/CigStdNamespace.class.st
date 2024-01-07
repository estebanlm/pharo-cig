"
This is the std:: C++ namespace, from which we just want what we need to translet from/to C++.

"
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
