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
