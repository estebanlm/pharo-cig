Class {
	#name : 'CigClassTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigClassTest >> testConstructorNameIsNew [
	| element |
	
	element := self translatedUnitNoise elementAtPath: { 'noise'. 'module'. 'Module'. 'Module(int)' }.

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

	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'RendererNormalMap' }.
	self assert: element shouldExposeDispose.
	
	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'NoiseMapBuilder' }.
	self deny: element shouldExposeDispose
]
