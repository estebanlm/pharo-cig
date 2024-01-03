Class {
	#name : 'IGClassTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
IGClassTest >> testConstructorNameIsNew [
	| element |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'Module(int)' }.

	self 
		assert: element cDeclaration 
		equals: 'no_noise_module_Module_new'
	
]

{ #category : 'tests' }
IGClassTest >> testMethodAnsweringAClassWithtReferenceAnswerACorrectPointer [
	| element |
	
	element := self translatedUnitTvision elementAtPath: { 'TPWrittenObjects' }.
	self deny: element shouldExposeDispose.
	
	element := self translatedUnitTvision elementAtPath: { 'TScreenCell' }.
	self deny: element shouldExposeDispose.
	
	element := self translatedUnitTvision elementAtPath: { 'TStreamableTypes' }.
	self assert: element shouldExposeDispose
]

{ #category : 'tests' }
IGClassTest >> testShouldExposeDispose [
	| element |

	element := self elementAtPath: { 'noise'. 'utils'. 'RendererNormalMap' }.
	self assert: element shouldExposeDispose.
	
	element := self elementAtPath: { 'noise'. 'utils'. 'NoiseMapBuilder' }.
	self deny: element shouldExposeDispose
]

{ #category : 'tests' }
IGClassTest >> testTemplateClass [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	self assert: element isClassTemplate.
	
	element := self translatedUnitTvision elementAtPath: { 'TScreenCell' }.
	self deny: element isClassTemplate
	
]

{ #category : 'tests' }
IGClassTest >> testTemplateClassHasTemplateTypeParameter [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	self denyEmpty: element templateTypeParameters
]
