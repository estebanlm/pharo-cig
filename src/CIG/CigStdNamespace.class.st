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

	self addElement: (CigStdElement newName: 'shared_ptr').
	self addElement: (CigStdElement newName: 'array').
	self addElement: ((CigStdElement newName: 'chrome')
		addElement: (CigStdElement newName: 'nanoseconds');
		yourself).
	self addElement: (CigStdElement newName: 'string').
	self addElement: (CigStdElement newName: 'wstring').
	self addElement: (CigStdElement newName: 'atomic').
	self addElement: (CigStdElement newName: 'mutex')
]
