Class {
	#name : 'CigCStructTemplate',
	#superclass : 'CigCTemplate',
	#category : 'CIG-C-Template',
	#package : 'CIG',
	#tag : 'C-Template'
}

{ #category : 'generating' }
CigCStructTemplate >> generate [

	^ String streamContents: [ :stream | 
		stream << 'struct ' << self element cDeclaration << ' {' .
		stream cr.
		self element fields 
			collect: [ :each | each cTemplate ]
			thenDo: [ :each |
				stream tab.
				stream << each generate << ';'.
				stream cr ].
		stream << '};' ]
]
