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
		equals: 'noise_module_Module_new'
	
]

{ #category : 'tests' }
IGClassTest >> testMethodAnsweringAClassPointerAnswerACorrectPointer [
	| element |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'Module(int)' }.

	self 
		assert: element resolveReturnType cDeclaration 
		equals: 'noise_module_Module*'
]

{ #category : 'tests' }
IGClassTest >> testMethodAnsweringAClassWithoutReferenceAnswerACorrectPointer [
	| element |
	
	element := self elementAtPath: { 'noise'. 'utils'. 'Image'. 'GetBorderValue()' }.

	self 
		assert: element resolveReturnType cDeclaration 
		equals: 'noise_utils_Color*'
]

{ #category : 'tests' }
IGClassTest >> testMethodAnsweringAClassWithtReferenceAnswerACorrectPointer [
	| element |
	
	element := self elementAtPath: { 'noise'. 'model'. 'Plane'. 'GetModule()' }.

	self 
		assert: element resolveReturnType cDeclaration 
		equals: 'noise_module_Module*'
]
