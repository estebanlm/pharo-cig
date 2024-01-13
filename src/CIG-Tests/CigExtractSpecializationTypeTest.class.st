Class {
	#name : 'CigExtractSpecializationTypeTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests-Misc',
	#package : 'CIG-Tests',
	#tag : 'Misc'
}

{ #category : 'tests' }
CigExtractSpecializationTypeTest >> testExtractSpecializationTypesWithConstant [
	| types |

	types := CigFunction new extractSpecializationTypesOf: 'std::array<abc,42>'.
	self assert: types equals: #('abc' '42')
]

{ #category : 'tests' }
CigExtractSpecializationTypeTest >> testExtractSpecializationTypesWithNestedTemplateTypeAndConstant [
	| types |

	types := CigFunction new extractSpecializationTypesOf: 'std::array<std::array<wchar,2>,256>'.
	self assert: types equals: #('std::array<wchar,2>' '256')
]
