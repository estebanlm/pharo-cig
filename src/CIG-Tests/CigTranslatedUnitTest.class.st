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
CigTranslatedUnitTest >> testFromImportImportsAlsoInnerElements [
	| unit |

	unit := CigCppLibraryGenerator new
		from: 'array' import: #('std::array');
		withoutSpecialElements;
		translateUnit.

	self assert: (unit elementAtPath: { 'std'. 'array' }) isNotNil.
	self assert: (unit elementAtPath: { 'std'. 'array' }) elements isNotEmpty
]

{ #category : 'tests' }
CigTranslatedUnitTest >> testIsLocationPartOfLibraryBaseHeaderFile [
	| unit |

	unit := CigTranslatedUnit basicNew.
	unit reset.
	
	self assert: (unit
		isLocationPartOfLibrary: '/home/esteban/dev/vm/libnoise/include/noise/model/line.h' 
		baseHeaderFile: '/home/esteban/dev/vm/libnoise/include/noise/noise.h').
]

{ #category : 'tests' }
CigTranslatedUnitTest >> testResolveIncludeFileName [
	"this is in fact a very weak test (since subdir will change as soon as I change the 
	 gcc version :("
	| unit |

	unit := CigCppTranslatedUnit new.
	self  
		assert: (unit resolveIncludeFileName: '/usr/include/c++/14.1.1/array')
		equals: '/usr/include/c++/14.1.1/array'.
		
	"this test is super fragile because it depends on where I have *now* the file"
	self  
		assert: (unit resolveIncludeFileName: 'array')
		equals: '/usr/include/c++/14.1.1/array'
]
