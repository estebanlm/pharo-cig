Class {
	#name : 'CigPharoStructureTemplateTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateSimpleStruct [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TResourceItem' }.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	int32_t pos;
	int32_t size;
	char* key
	)'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateStructWithUnion [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'MessageEvent' }.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	tv_ushort command;
	TvMessageEventUnion1 union1
	)'
]
