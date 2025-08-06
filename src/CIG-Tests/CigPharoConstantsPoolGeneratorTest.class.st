Class {
	#name : 'CigPharoConstantsPoolGeneratorTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'running' }
CigPharoConstantsPoolGeneratorTest >> tearDown [

	PackageOrganizer default 
		packageNamed: #UnitToTest
		ifPresent: [ :aPackage | aPackage removeFromSystem ].
		
	super tearDown
]

{ #category : 'tests' }
CigPharoConstantsPoolGeneratorTest >> testAddClassWithConstants [
	| gen file unit result |

	file := CigCLibraryGenerator new 
		packageName: 'UnitToTest';
		libraryName: 'unittotest';
		importUnit: '
#define MACRO 42
#define MACRO_STRING "Hello, World"
#define MACRO_CHAR ''A''';
		yourself.
		
	unit := file translateUnit.

	gen := CigPharoConstantsPoolGenerator newFile: file unit: unit. 

	gen addClassWithConstants: #('MACRO' 'MACRO_STRING' 'MACRO_CHAR').
	result := gen generatedClass.

	self assert: result name equals: 'UnittotestConstants'.
	self assert: result classPool size equals: 3
]

{ #category : 'tests' }
CigPharoConstantsPoolGeneratorTest >> testCollectConstantValues [
	| gen file unit result |

	file := CigCLibraryGenerator new 
		packageName: 'UnitToTest';
		libraryName: 'unittotest';
		importUnit: '
#define MACRO 42
#define MACRO_STRING "Hello, World"
#define MACRO_CHAR ''A''';
		yourself.
		
	unit := file translateUnit.

	gen := CigPharoConstantsPoolGenerator newFile: file unit: unit. 

	result := gen collectConstantValues: #('MACRO' 'MACRO_STRING' 'MACRO_CHAR').

	self assert: (result at: 'MACRO') equals: 42.
	self assert: (result at: 'MACRO_STRING') equals: 'Hello, World'.	
	self assert: (result at: 'MACRO_CHAR') equals: 65
]

{ #category : 'tests' }
CigPharoConstantsPoolGeneratorTest >> testGenerateConstants [
	| gen file unit result |

	file := CigCLibraryGenerator new 
		packageName: 'UnitToTest';
		libraryName: 'unittotest';
		importUnit: '
#define MACRO 42
#define MACRO_STRING "Hello, World"
#define MACRO_CHAR ''A''';
		yourself.
		
	unit := file translateUnit.

	gen := CigPharoConstantsPoolGenerator newFile: file unit: unit. 

	gen generateConstants: #('MACRO' 'MACRO_STRING' 'MACRO_CHAR').
	result := gen generatedClass.

	self assert: result name equals: 'UnittotestConstants'.
	self assert: result classPool size equals: 3.
	
	self assert: result MACRO equals: 42.
	self assert: result MACRO_STRING equals: 'Hello, World'.
	self assert: result MACRO_CHAR equals: 65
]
