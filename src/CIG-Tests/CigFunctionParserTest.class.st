Class {
	#name : 'CigFunctionParserTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests-Misc',
	#package : 'CIG-Tests',
	#tag : 'Misc'
}

{ #category : 'tests' }
CigFunctionParserTest >> testParseClassTemplateNestedType [
	| type |

	type := CigFunctionParser new
		setOn: 'std::array<std::array<x,42>, 2>';
		parseType.
	
	self assert: type fourth equals: #('std::array<x,42>' '2')
]

{ #category : 'tests' }
CigFunctionParserTest >> testParseClassTemplateType [
	| type |

	type := CigFunctionParser new
		setOn: 'TSpan<T>';
		parseType.
	
	self assert: type fourth equals: #('T')
]

{ #category : 'tests' }
CigFunctionParserTest >> testParsePointerPointerType [
	| type |

	type := CigFunctionParser new
		setOn: 'void**';
		parseType.
	
	self assert: type second equals: 2
]

{ #category : 'tests' }
CigFunctionParserTest >> testParsePointerType [
	| type |

	type := CigFunctionParser new
		setOn: 'void*';
		parseType.
	
	self assert: type second equals: 1
]

{ #category : 'tests' }
CigFunctionParserTest >> testParseReferenceType [
	| type |

	type := CigFunctionParser new
		setOn: 'void*&';
		parseType.
	
	self assert: type second equals: 2
]

{ #category : 'tests' }
CigFunctionParserTest >> testParseSpecializationType [
	| name |

	name := (CigFunctionParser parse: 'std::array<wchar_t, 2>') nameWithArity.
	self assert: name equals: 'std::array<wchar_t, 2>'
]
