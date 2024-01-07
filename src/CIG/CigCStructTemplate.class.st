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
		stream << self structureType.
		self element isAnonymous 
			ifFalse:[ stream << ' ' << self element cDeclaration ].
		stream  << ' {' .
		stream cr.
		self element fields 
			collect: [ :each | each cTemplate ]
			thenDo: [ :eachTemplate | | genLines |
				genLines := eachTemplate generate lines.
				genLines size = 1 
					ifTrue: [ 
						stream tab.
						stream << genLines first << ';' ]
					ifFalse: [ 
						 genLines
							do: [ :each | 
								stream tab. 
								stream << each ]
							separatedBy: [ stream cr ] ].
				stream cr ].
		stream << '};' ]
]

{ #category : 'private' }
CigCStructTemplate >> structureType [
	
	^ 'struct'
]
