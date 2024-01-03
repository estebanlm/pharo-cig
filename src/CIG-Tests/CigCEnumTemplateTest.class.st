Class {
	#name : 'CigCEnumTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C-Template',
	#package : 'CIG-Tests',
	#tag : 'C-Template'
}

{ #category : 'tests' }
CigCEnumTemplateTest >> testGenerateNested [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'ConsoleType' }.
	template := CigCEnumTemplate for: element.
	
	self
		assert: template generate
		equals: 'enum tv_THardwareInfo_ConsoleType {
    cnInput = 0,
    cnOutput = 1,
    cnStartup = 2
};'
]

{ #category : 'tests' }
CigCEnumTemplateTest >> testGenerateTypedef [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'StreamableInit' }.
	template := CigCEnumTemplate for: element.
	
	self
		assert: template generate 
		equals: 'typedef int tv_StreamableInit;'
]
