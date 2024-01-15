Class {
	#name : 'CigStructureTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigStructureTest >> testFieldsAnswerAlsoVariables [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'fLink' }.

	self assert: element fields size equals: 3
]

{ #category : 'tests' }
CigStructureTest >> testStructureWithClassInstanceTypeExportsAsClass [
	| element |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FTermData'. 'TerminalProperties' }.

	"can't be exported (as this is in the private section)"
	self deny: element canBeExported.
	"... but I will check it anyway"
	self assert: element isClass
]

{ #category : 'tests' }
CigStructureTest >> testStructureWithSpecialTypesExportsAsClass [
	| element |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FTermData'. 'SynchronizationState' }.

	"it can't be exported as this is in the private section"
	self deny: element canBeExported.
	"... but I test it anyway"
	self assert: element isClass
]
