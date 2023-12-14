Class {
	#name : 'IGFunctionParserTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

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
