Class {
	#name : 'CXTokenKind',
	#superclass : 'SharedPool',
	#classVars : [
		'CXToken_Comment',
		'CXToken_Identifier',
		'CXToken_Keyword',
		'CXToken_Literal',
		'CXToken_Punctuation'
	],
	#category : 'CIG-LibClang',
	#package : 'CIG-LibClang'
}

{ #category : 'class initialization' }
CXTokenKind class >> initialize [

	CXToken_Punctuation := 0.
	CXToken_Keyword := 1.
	CXToken_Identifier := 2.
	CXToken_Literal := 3.
	CXToken_Comment := 4

]
