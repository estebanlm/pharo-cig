Class {
	#name : 'CigCEnumTypedefTemplate',
	#superclass : 'CigCEnumTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
CigCEnumTypedefTemplate class >> handlesElement: anElement [

	^ true
	"^ anElement depth = 1"
]

{ #category : 'generating' }
CigCEnumTypedefTemplate >> generate [
	
	^ String streamContents: [ :stream |
		stream << 'typedef ' << self element cppDeclaration << ' ' << self element fullName << ';' ]
]
