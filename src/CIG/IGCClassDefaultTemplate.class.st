Class {
	#name : 'IGCClassDefaultTemplate',
	#superclass : 'IGCClassTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'generating' }
IGCClassDefaultTemplate >> generateHeader [
	
	^ String streamContents: [ :stream |
		stream << 'typedef void ' << self element fullName << ';' ]
]
