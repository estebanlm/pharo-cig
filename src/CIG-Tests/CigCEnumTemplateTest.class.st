Class {
	#name : 'CigCEnumTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
CigCEnumTemplateTest >> testGenerateNested [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'ConsoleType' }.
	template := CigCEnumTemplate for: element.
	
	self
		assert: template generate
		equals: 'typedef THardwareInfo::ConsoleType tv_THardwareInfo_ConsoleType;'
]

{ #category : 'tests' }
CigCEnumTemplateTest >> testGenerateTypedef [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'StreamableInit' }.
	template := element cTemplate.
	
	self
		assert: template generate 
		equals: 'typedef StreamableInit tv_StreamableInit;'
]
