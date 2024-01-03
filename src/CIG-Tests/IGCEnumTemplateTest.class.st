Class {
	#name : 'IGCEnumTemplateTest',
	#superclass : 'IGCTemplateTest',
	#category : 'CIG-Tests-C-Template',
	#package : 'CIG-Tests',
	#tag : 'C-Template'
}

{ #category : 'tests' }
IGCEnumTemplateTest >> testGenerateNested [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'ConsoleType' }.
	template := IGCEnumTemplate for: element.
	
	self
		assert: template generate
		equals: 'enum tv_THardwareInfo_ConsoleType {
    cnInput = 0,
    cnOutput = 1,
    cnStartup = 2
};'
]

{ #category : 'tests' }
IGCEnumTemplateTest >> testGenerateTypedef [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'StreamableInit' }.
	template := IGCEnumTemplate for: element.
	
	self
		assert: template generate 
		equals: 'typedef int tv_StreamableInit;'
]
