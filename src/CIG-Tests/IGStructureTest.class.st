Class {
	#name : 'IGStructureTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'tests' }
IGStructureTest >> testFieldsAnswerAlsoVariables [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'fLink' }.

	self assert: element fields size equals: 3
]
