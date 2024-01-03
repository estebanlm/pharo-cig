Class {
	#name : 'CigClassTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
CigClassTest >> testConstructorNameIsNew [
	| element |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'Module(int)' }.

	self 
		assert: element cDeclaration 
		equals: 'no_noise_module_Module_new'
	
]

{ #category : 'tests' }
CigClassTest >> testMethodAnsweringAClassWithtReferenceAnswerACorrectPointer [
	| element |
	
	element := self translatedUnitTvision elementAtPath: { 'TPWrittenObjects' }.
	self deny: element shouldExposeDispose.
	
	element := self translatedUnitTvision elementAtPath: { 'TScreenCell' }.
	self deny: element shouldExposeDispose.
	
	element := self translatedUnitTvision elementAtPath: { 'TStreamableTypes' }.
	self assert: element shouldExposeDispose
]

{ #category : 'tests' }
CigClassTest >> testShouldExposeDispose [
	| element |

	element := self elementAtPath: { 'noise'. 'utils'. 'RendererNormalMap' }.
	self assert: element shouldExposeDispose.
	
	element := self elementAtPath: { 'noise'. 'utils'. 'NoiseMapBuilder' }.
	self deny: element shouldExposeDispose
]

{ #category : 'tests' }
CigClassTest >> testTemplateClass [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	self assert: element isClassTemplate.
	
	element := self translatedUnitTvision elementAtPath: { 'TScreenCell' }.
	self deny: element isClassTemplate
	
]

{ #category : 'tests' }
CigClassTest >> testTemplateClassHasTemplateTypeParameter [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	self denyEmpty: element templateTypeParameters
]
