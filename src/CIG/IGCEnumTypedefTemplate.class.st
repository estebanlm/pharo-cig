Class {
	#name : 'IGCEnumTypedefTemplate',
	#superclass : 'IGCEnumTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCEnumTypedefTemplate class >> handlesElement: anElement [

	^ anElement depth = 1
]

{ #category : 'generating' }
IGCEnumTypedefTemplate >> generate [
	
	^ String streamContents: [ :stream |
		stream << 'typedef int ' << self element fullName << ';' ]
]
