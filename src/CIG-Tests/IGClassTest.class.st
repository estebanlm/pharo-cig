Class {
	#name : 'IGClassTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
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
IGClassTest >> testMethodAnsweringAClassPointerAnswerACorrectPointer [
	| element |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'Module(int)' }.

	self 
		assert: element resolveReturnType cDeclaration 
		equals: 'no_noise_module_Module*'
]

{ #category : 'tests' }
IGClassTest >> testMethodAnsweringAClassWithoutReferenceAnswerACorrectPointer [
	| element |
	
	element := self elementAtPath: { 'noise'. 'utils'. 'Image'. 'GetBorderValue()' }.

	self 
		assert: element resolveReturnType cDeclaration 
		equals: 'nu_noise_utils_Color*'
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
