Class {
	#name : 'CigPharoFieldTemplateTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateSimpleFieldDesc [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TResourceItem' }.
	template := element fields first phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: 'int32_t pos'
]

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateUnionFieldDesc [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'MessageEvent' }.
	template := element fields second phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: 'TvMessageEventUnion1 union1'
]
