Class {
	#name : 'IGCEnumDefaultTemplate',
	#superclass : 'IGCEnumTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'private' }
IGCEnumDefaultTemplate class >> handlesElement: anElement [

	^ anElement depth > 1
]

{ #category : 'generating' }
IGCEnumDefaultTemplate >> generate [
	
	^ String streamContents: [ :stream |
			stream << 'enum ' << self enumName << ' {'.
			stream cr.
			self element elements 
				do: [ :each | stream << '    ' << each name << ' = ' << each value asString ]
				separatedBy: [ stream << ',' << String cr ].
			stream cr. 
			stream << '};' ]
]
