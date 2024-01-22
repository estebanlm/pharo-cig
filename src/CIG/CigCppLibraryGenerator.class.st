"
Generator for C++ libraries. 
In addition to generate Pharo classes to call the library, this generator can generate a bindings library (a library that ""flattens"") the C++ library and creates a set of functions/structures/enums/etc. that can be used with uFFI.

## Example

```smalltalk

(noise := CigCppLibraryGenerator new)
	prefix: 'No';
	bindingsName: 'noise';
	file: '/home/esteban/dev/vm/libnoise/include/noise/noise.h';
	cIncludePath: '/home/esteban/dev/vm/libnoise/include';
	cIncludePath: '/home/esteban/dev/vm/libnoise/include/noise';
	cLib: 'noise';
	withCBindings;
	withMakefile;
	withClasses.
	
noise generate.
noise buildBindingsLibrary.
```
"
Class {
	#name : 'CigCppLibraryGenerator',
	#superclass : 'CigLibraryGenerator',
	#instVars : [
		'withMakefile',
		'withCBindings'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'building' }
CigCppLibraryGenerator >> buildBindingsLibrary [
	
	LibC system: 'make'
]

{ #category : 'generating' }
CigCppLibraryGenerator >> generate [
	| unit |

	('Initiate generation of {1}' format: { self fileReference basename }) asBeaconSignal emit.
	'Collecting nodes' asBeaconSignal emit.
	
	unit := self translateUnit.

	self hasCBindings ifTrue: [ self generateCBindingsWith: unit ].
	self hasMakefile ifTrue: [ self generateMakefile ].
	self hasClasses ifTrue: [ self generatePharoClassesWith: unit ]
]

{ #category : 'generating' }
CigCppLibraryGenerator >> generateCBindingsWith: unit [

	('Generating C file: {1}.' format: { self cFileReference basename }) asBeaconSignal emit.
	CigCVisitor new
		file: self;
		visit: unit
]

{ #category : 'generating' }
CigCppLibraryGenerator >> generateMakefile [
	| template |

	'Generating Makefile.' asBeaconSignal emit.

	template := '
INCLUDE_DIRS={include}
LIBS={libs}

{libName}.so: {libName}.cpp
	clang -xc++ -fPIC --shared $(INCLUDE_DIRS) $(LIBS) {libName}.cpp -o {libName}.so
' format: { 
		#libName->self libraryName.
		#include->(String streamContents: [ :s | 
			self cIncludePathsAsArguments asStringOn: s delimiter: ' ' ]).
		#libs->(String streamContents: [ :s | 
			self cLibsAsArguments asStringOn: s delimiter: ' ' ]) }
	asDictionary.

	self makefileReference 
		ensureDelete;
		writeStreamDo: [ :stream |
			(ZnNewLineWriterStream on: stream) << template ]	
]

{ #category : 'testing' }
CigCppLibraryGenerator >> hasCBindings [

	^ withCBindings
]

{ #category : 'testing' }
CigCppLibraryGenerator >> hasMakefile [

	^ withMakefile
]

{ #category : 'initialization' }
CigCppLibraryGenerator >> initialize [

	super initialize.
	self withCBindings.
	self withMakefile
]

{ #category : 'accessing - configuration' }
CigCppLibraryGenerator >> withCBindings [

	withCBindings := true
]

{ #category : 'accessing - configuration' }
CigCppLibraryGenerator >> withMakefile [

	withMakefile := true
]

{ #category : 'accessing - configuration' }
CigCppLibraryGenerator >> withoutCBindings [

	withCBindings := false
]

{ #category : 'accessing - configuration' }
CigCppLibraryGenerator >> withoutMakefile [

	withMakefile := false
]
