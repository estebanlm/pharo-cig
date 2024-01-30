Class {
	#name : 'CigCppTranslatedUnitTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigCppTranslatedUnitTest >> testAddIncludedElements [
	| gen |
	
	gen := CigCppTranslatedUnit newForTest.
	gen including: { '/usr/include/c++/13.2.1/array' -> #('std::array') } asDictionary.
	
	gen addIncludedElements.
	
	self assert: (gen elementAtPath: { 'std'. 'array' }) isNotNil
		
]
