Class {
	#name : 'CigTranslatedUnitTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigTranslatedUnitTest >> testFromImport [
	| unit |

	unit := CigCppLibraryGenerator new
		from: 'array' import: #('std::array');
		withoutSpecialElements;
		translateUnit.

	self assert: (unit elementAtPath: { 'std'. 'array' }) notNil.
	self assert: (unit elementAtPath: { 'std' }) elements size equals: 1
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
