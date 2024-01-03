Class {
	#name : 'CigCClassDefaultTemplate',
	#superclass : 'CigCClassTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'generating' }
CigCClassDefaultTemplate >> generateHeader [
	
	^ String streamContents: [ :stream |
		stream << 'typedef void ' << self element fullName << ';' ]
]
