Class {
	#name : 'IGFunctionParserTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests-Misc',
	#package : 'CIG-Tests',
	#tag : 'Misc'
}

{ #category : 'tests' }
IGFunctionParserTest >> testParseClassTemplateType [
	| type |

	type := IGFunctionParser new
		setOn: 'TSpan<T>';
		parseType.
	
	self assert: type fourth equals: 'T'
]

{ #category : 'tests' }
IGFunctionParserTest >> testParsePointerPointerType [
	| type |

	type := IGFunctionParser new
		setOn: 'void**';
		parseType.
	
	self assert: type second equals: 2
]

{ #category : 'tests' }
IGFunctionParserTest >> testParsePointerType [
	| type |

	type := IGFunctionParser new
		setOn: 'void*';
		parseType.
	
	self assert: type second equals: 1
]

{ #category : 'tests' }
IGFunctionParserTest >> testParseReferenceType [
	| type |

	type := IGFunctionParser new
		setOn: 'void*&';
		parseType.
	
	self assert: type second equals: 2
]
