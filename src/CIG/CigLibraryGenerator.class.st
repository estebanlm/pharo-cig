"
This is a generator of C bindings for CPP libraries. 
It takes the declaring header (plus some configuration files) and is capable of generate the corresponfing C bindings file, an associated Makefile and also all the Pharo classes included.

## Example

```
(noise := IGHeaderGenerator new)
	prefix: 'No';
	bindingsName: 'noise'; 
	file: '/home/esteban/dev/vm/libnoise/include/noise/noise.h';
	includePaths: {
		'/home/esteban/dev/vm/libnoise/include'.
		'/home/esteban/dev/vm/libnoise/include/noise' };
	libs: { 
		'noise' };
	withMakefile;
	withoutClasses.

	noise generate.
```
"
Class {
	#name : 'CigLibraryGenerator',
	#superclass : 'Object',
	#instVars : [
		'includePaths',
		'withMakefile',
		'withCBindings',
		'withClasses',
		'libs',
		'prefix',
		'bindingsName',
		'fileReference',
		'namespaces',
		'withComments',
		'defines',
		'definesBeforeHeader'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigLibraryGenerator >> bindingsName [

	^ bindingsName ifNil: [ bindingsName := self files first basenameWithoutExtension ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> bindingsName: aString [

	bindingsName := aString
]

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> cDefine: aString [

	self cDefine: aString as: nil
]

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> cDefine: aKey as: aValue [

	defines ifNil: [ defines := OrderedDictionary new ].
	defines at: aKey put: aValue
]

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> cDefineBeforeHeader: aString [

	self cDefineBeforeHeader: aString as: nil
]

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> cDefineBeforeHeader: aKey as: aValue [

	definesBeforeHeader ifNil: [ definesBeforeHeader := OrderedDictionary new ].
	definesBeforeHeader at: aKey put: aValue
]

{ #category : 'accessing' }
CigLibraryGenerator >> cDefines [

	^ defines ifNil: [ Dictionary new ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> cDefines: aCollection [

	aCollection	do: [ :each | 
		self cDefine: each ]
]

{ #category : 'private' }
CigLibraryGenerator >> cDefinesAsArguments [

	^ self cDefines associations collect: [ :assoc | 
			String streamContents: [ :stream |
				stream << '-D' << assoc key asString.
				assoc value ifNotNil: [ stream << '=' << assoc value asString ] ] ]
]

{ #category : 'accessing' }
CigLibraryGenerator >> cDefinesBeforeHeader [

	^ definesBeforeHeader ifNil: [ Dictionary new ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> cDefinesBeforeHeader: aCollection [

	aCollection	do: [ :each | 
		self cDefineBeforeHeader: each ]
]

{ #category : 'private' }
CigLibraryGenerator >> cDefinesBeforeHeaderAsArguments [

	^ self cDefinesBeforeHeader associations collect: [ :assoc | 
			String streamContents: [ :stream |
				stream << '-D' << assoc key asString.
				assoc value ifNotNil: [ stream << '=' << assoc value asString ] ] ]
]

{ #category : 'accessing' }
CigLibraryGenerator >> cFileReference [
	"where the wrapper functions will be placed"
	
	^ (FileLocator imageDirectory / (self bindingsName, '_bindings')) withExtension: 'cpp'
]

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> cIncludePath: aStringOrReference [

	includePaths ifNil: [ includePaths := #() ].
	includePaths := includePaths copyWith: aStringOrReference asFileReference fullName
]

{ #category : 'accessing' }
CigLibraryGenerator >> cIncludePaths [
	"include paths to put in the include path (-I paramters) in clang, to make sure all 
	 dependencies are found."

	^ includePaths ifNil: [ #() ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> cIncludePaths: aCollection [

	includePaths := aCollection
]

{ #category : 'private' }
CigLibraryGenerator >> cIncludePathsAsArguments [

	^ self cIncludePaths collect: [ :each | '-I', each ]
]

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> cLib: aStringOrReference [

	libs ifNil: [ libs := #() ].
	libs := libs copyWith: aStringOrReference
]

{ #category : 'accessing' }
CigLibraryGenerator >> cLibs [

	^ libs
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> cLibs: aCollection [

	libs := aCollection
]

{ #category : 'private' }
CigLibraryGenerator >> cLibsAsArguments [

	^ self cLibs collect: [ :each | '-l', each ]
]

{ #category : 'private' }
CigLibraryGenerator >> defaultPrefix [

	^ (self bindingsName first: 2) capitalized
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> file: aFileReferenceOrString [

	fileReference := aFileReferenceOrString asFileReference
]

{ #category : 'accessing' }
CigLibraryGenerator >> fileReference [

	^ fileReference
]

{ #category : 'generating' }
CigLibraryGenerator >> generate [
	| unit |

	('Initiate generation of {1}' format: { self fileReference basename }) asBeaconSignal emit.
	'Collecting nodes' asBeaconSignal emit.
	
	unit := self translateUnit.

	self hasCBindings ifTrue: [ self generateCBindingsWith: unit ].
	self hasMakefile ifTrue: [ self generateMakefile ].
	self hasClasses ifTrue: [ self generatePharoClassesWith: unit ]
]

{ #category : 'generating' }
CigLibraryGenerator >> generateCBindingsWith: unit [

	('Generating C file: {1}.' format: { self cFileReference basename }) asBeaconSignal emit.
	CigCVisitor new
		file: self;
		visit: unit
]

{ #category : 'generating' }
CigLibraryGenerator >> generateMakefile [
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

{ #category : 'generating' }
CigLibraryGenerator >> generatePharoClassesWith: aUnit [
	
	'Generating Pharo classes.' asBeaconSignal emit.
	CigPharoVisitor new
		file: self;
		visit: aUnit
]

{ #category : 'testing' }
CigLibraryGenerator >> hasCBindings [

	^ withCBindings
]

{ #category : 'testing' }
CigLibraryGenerator >> hasClasses [

	^ withClasses
]

{ #category : 'testing' }
CigLibraryGenerator >> hasComments [

	^ withComments
]

{ #category : 'testing' }
CigLibraryGenerator >> hasMakefile [

	^ withMakefile
]

{ #category : 'testing' }
CigLibraryGenerator >> includesNamespace: aString [

	^ self namespaces anySatisfy: [ :each | each cppName = aString ]
]

{ #category : 'initialization' }
CigLibraryGenerator >> initialize [

	super initialize.
	self withCBindings.
	self withoutMakefile.
	self withoutClasses.
	self withoutComments
]

{ #category : 'accessing' }
CigLibraryGenerator >> libraryClassName [
	"Pharo class name to store the wrapped functions"
	
	^ self fileReference basenameWithoutExtension capitalized
]

{ #category : 'accessing' }
CigLibraryGenerator >> libraryName [

	^ self cFileReference basenameWithoutExtension
]

{ #category : 'private' }
CigLibraryGenerator >> listElements [
	"makes a tree of elements I can use to generate the wrapper file and classes."
	| elements cursor tu index |
	
	index := CXIndex createIndex: 0 diagnostics: 0. 
	tu := CXTranslationUnit 
		parseIndex: index 
		fileName: self fileReference fullName
		arguments: {
				'-E'.
				'-xc++'.
			}, 
			self cIncludePathsAsArguments.
	
	elements := OrderedCollection new.
	cursor := tu cursor.
	cursor visitChildren: [ :current :parent :data |
		current location isInSystemHeader 
			ifFalse: [ elements add: current displayName -> current kindSpelling ].
		CXChildVisit recurse ].

	tu dispose.
	index dispose.
	
	^ elements
]

{ #category : 'accessing' }
CigLibraryGenerator >> makefileReference [
	
	^ FileLocator imageDirectory / 'Makefile'
]

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> namespace: aNamespaceClass [

	namespaces ifNil: [ namespaces := #() ].
	namespaces := namespaces copyWith: aNamespaceClass
]

{ #category : 'accessing' }
CigLibraryGenerator >> namespaces [

	^ namespaces ifNil: [ #() ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> namespaces: aCollection [

	namespaces := aCollection
]

{ #category : 'accessing' }
CigLibraryGenerator >> prefix [

	^ prefix ifNil: [ prefix := self defaultPrefix ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> prefix: aPrefix [
	
	prefix := aPrefix
]

{ #category : 'generating' }
CigLibraryGenerator >> translateUnit [
	
	^ CigTranslatedUnit new
		generateFrom: self;
		yourself
]

{ #category : 'generating' }
CigLibraryGenerator >> translateUnitWithoutUnkown [
	
	^ CigTranslatedUnit new
		withoutUnknown;
		generateFrom: self;
		yourself
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withCBindings [

	withCBindings := true
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withClasses [

	withClasses := true
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withComments [

	withComments := true
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withMakefile [

	withMakefile := true
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withoutCBindings [

	withCBindings := false
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withoutClasses [

	withClasses := false
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withoutComments [

	withComments := false
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withoutMakefile [

	withMakefile := false
]
