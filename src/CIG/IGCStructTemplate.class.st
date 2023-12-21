Class {
	#name : 'IGCStructTemplate',
	#superclass : 'IGCTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'generating' }
IGCStructTemplate >> generate [

	^ String streamContents: [ :stream | 
		stream << 'struct ' << self element cDeclaration << ' {' .
		stream cr.
		self element fields 
			collect: [ :each | IGCParameterTemplate forField: each ]
			thenDo: [ :each |
				stream tab.
				stream << each generate << ';'.
				stream cr ].
		stream << '};' ]
]
