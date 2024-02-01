Class {
	#name : 'CigTranslatedUnitTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigTranslatedUnitTest >> testAddIncludedElements [
	| gen |
	
	gen := CigCppTranslatedUnit newForTest.
	gen including: { '/usr/include/c++/13.2.1/array' -> #('std::array') } asDictionary.
	
	gen addIncludedElements.
	
	self assert: (gen elementAtPath: { 'std'. 'array' }) isNotNil
		
]

{ #category : 'tests' }
CigTranslatedUnitTest >> testResolveIncludeFileName [
	| unit |

	unit := CigCppTranslatedUnit new.
	self  
		assert: (unit resolveIncludeFileName: '/usr/include/c++/13.2.1/array')
		equals: '/usr/include/c++/13.2.1/array'.
		
	"this test is super fragile because it depends on where I have *now* the file"
	self  
		assert: (unit resolveIncludeFileName: 'array')
		equals: '/usr/include/c++/13.2.1/array'
]
