Class {
	#name : 'CigCTypedefTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C-Template',
	#package : 'CIG-Tests',
	#tag : 'C-Template'
}

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateArrayType [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TScrollChars' }.
	template := CigCTypedefTemplate for: element.
	
	self 
		assert: template generate
		equals: 'typedef char* tv_TScrollChars;'
]

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateBasicType [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'ushort' }.
	template := CigCTypedefTemplate for: element.
	
	self 
		assert: template generate
		equals: 'typedef unsigned short tv_ushort;'
]

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateFunctionType [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TEditorDialog' }.
	template := CigCTypedefTemplate for: element.
	
	self 
		assert: template generate
		equals: 'typedef void* tv_TEditorDialog;'
]
