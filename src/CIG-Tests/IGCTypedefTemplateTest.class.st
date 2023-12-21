Class {
	#name : 'IGCTypedefTemplateTest',
	#superclass : 'IGCTemplateTest',
	#category : 'CIG-Tests-Template',
	#package : 'CIG-Tests',
	#tag : 'Template'
}

{ #category : 'tests' }
IGCTypedefTemplateTest >> testGenerateArrayType [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TScrollChars' }.
	template := IGCTypedefTemplate for: element.
	
	self 
		assert: template generate
		equals: 'typedef char* tv_TScrollChars;'
]

{ #category : 'tests' }
IGCTypedefTemplateTest >> testGenerateBasicType [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'ushort' }.
	template := IGCTypedefTemplate for: element.
	
	self 
		assert: template generate
		equals: 'typedef unsigned short tv_ushort;'
]

{ #category : 'tests' }
IGCTypedefTemplateTest >> testGenerateFunctionType [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TEditorDialog' }.
	template := IGCTypedefTemplate for: element.
	
	self 
		assert: template generate
		equals: 'typedef void* tv_TEditorDialog;'
]
