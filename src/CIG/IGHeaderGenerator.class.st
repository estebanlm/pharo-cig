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
	#name : 'IGHeaderGenerator',
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
IGHeaderGenerator >> bindingsName [

	^ bindingsName ifNil: [ bindingsName := self files first basenameWithoutExtension ]
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> bindingsName: aString [

	bindingsName := aString
]

{ #category : 'scripting' }
IGHeaderGenerator >> cDefine: aString [

	self cDefine: aString as: nil
]

{ #category : 'scripting' }
IGHeaderGenerator >> cDefine: aKey as: aValue [

	defines ifNil: [ defines := OrderedDictionary new ].
	defines at: aKey put: aValue
]

{ #category : 'scripting' }
IGHeaderGenerator >> cDefineBeforeHeader: aString [

	self cDefineBeforeHeader: aString as: nil
]

{ #category : 'scripting' }
IGHeaderGenerator >> cDefineBeforeHeader: aKey as: aValue [

	definesBeforeHeader ifNil: [ definesBeforeHeader := OrderedDictionary new ].
	definesBeforeHeader at: aKey put: aValue
]

{ #category : 'accessing' }
IGHeaderGenerator >> cDefines [

	^ defines ifNil: [ Dictionary new ]
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> cDefines: aCollection [

	aCollection	do: [ :each | 
		self cDefine: each ]
]

{ #category : 'private' }
IGHeaderGenerator >> cDefinesAsArguments [

	^ self cDefines associations collect: [ :assoc | 
			String streamContents: [ :stream |
				stream << '-D' << assoc key asString.
				assoc value ifNotNil: [ stream << '=' << assoc value asString ] ] ]
]

{ #category : 'accessing' }
IGHeaderGenerator >> cDefinesBeforeHeader [

	^ definesBeforeHeader ifNil: [ Dictionary new ]
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> cDefinesBeforeHeader: aCollection [

	aCollection	do: [ :each | 
		self cDefineBeforeHeader: each ]
]

{ #category : 'private' }
IGHeaderGenerator >> cDefinesBeforeHeaderAsArguments [

	^ self cDefinesBeforeHeader associations collect: [ :assoc | 
			String streamContents: [ :stream |
				stream << '-D' << assoc key asString.
				assoc value ifNotNil: [ stream << '=' << assoc value asString ] ] ]
]

{ #category : 'accessing' }
IGHeaderGenerator >> cFileReference [
	"where the wrapper functions will be placed"
	
	^ (FileLocator imageDirectory / (self bindingsName, '_bindings')) withExtension: 'cpp'
]

{ #category : 'scripting' }
IGHeaderGenerator >> cIncludePath: aStringOrReference [

	includePaths ifNil: [ includePaths := #() ].
	includePaths := includePaths copyWith: aStringOrReference asFileReference fullName
]

{ #category : 'accessing' }
IGHeaderGenerator >> cIncludePaths [
	"include paths to put in the include path (-I paramters) in clang, to make sure all 
	 dependencies are found."

	^ includePaths ifNil: [ #() ]
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> cIncludePaths: aCollection [

	includePaths := aCollection
]

{ #category : 'private' }
IGHeaderGenerator >> cIncludePathsAsArguments [

	^ self cIncludePaths collect: [ :each | '-I', each ]
]

{ #category : 'scripting' }
IGHeaderGenerator >> cLib: aStringOrReference [

	libs ifNil: [ libs := #() ].
	libs := libs copyWith: aStringOrReference asFileReference fullName
]

{ #category : 'accessing' }
IGHeaderGenerator >> cLibs [

	^ libs
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> cLibs: aCollection [

	libs := aCollection
]

{ #category : 'private' }
IGHeaderGenerator >> cLibsAsArguments [

	^ self cLibs collect: [ :each | '-l', each ]
]

{ #category : 'private' }
IGHeaderGenerator >> defaultPrefix [

	^ (self bindingsName first: 2) capitalized
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> file: aFileReferenceOrString [

	fileReference := aFileReferenceOrString asFileReference
]

{ #category : 'accessing' }
IGHeaderGenerator >> fileReference [

	^ fileReference
]

{ #category : 'generating' }
IGHeaderGenerator >> generate [
	| unit |

	('Initiate generation of {1}' format: { self fileReference basename }) asBeaconSignal emit.
	'Collecting nodes' asBeaconSignal emit.
	
	unit := self translateUnit.

	self hasCBindings ifTrue: [ self generateCBindingsWith: unit ].
	self hasMakefile ifTrue: [ self generateMakefile ].
	self hasClasses ifTrue: [ self generatePharoClassesWith: unit ]
]

{ #category : 'generating' }
IGHeaderGenerator >> generateCBindingsWith: unit [

	('Generating C file: {1}.' format: { self cFileReference basename }) asBeaconSignal emit.
	IGCVisitor new
		file: self;
		visit: unit
]

{ #category : 'generating' }
IGHeaderGenerator >> generateMakefile [
	| template |

	'Generating Makefile.' asBeaconSignal emit.

	template := '
INCLUDE_DIRS={2}
LIBS={3}

{1}.so: {1}.cpp
	clang -xc++ -fPIC --shared $(INCLUDE_DIRS) $(LIBS) {1}.cpp -o {1}.so
' format: { 
	self libraryName.
	(String streamContents: [ :s | 
		self cIncludePathsAsArguments asStringOn: s delimiter: ' ' ]).
	(String streamContents: [ :s | 
		self cLibsAsArguments asStringOn: s delimiter: ' ' ]) }.

	self makefileReference 
		ensureDelete;
		writeStreamDo: [ :stream |
			(ZnNewLineWriterStream on: stream) << template ]	
]

{ #category : 'generating' }
IGHeaderGenerator >> generatePharoClassesWith: aUnit [
	
	'Generating Pharo classes.' asBeaconSignal emit.
	IGPharoVisitor new
		file: self;
		visit: aUnit
]

{ #category : 'testing' }
IGHeaderGenerator >> hasCBindings [

	^ withCBindings
]

{ #category : 'testing' }
IGHeaderGenerator >> hasClasses [

	^ withClasses
]

{ #category : 'testing' }
IGHeaderGenerator >> hasComments [

	^ withComments
]

{ #category : 'testing' }
IGHeaderGenerator >> hasMakefile [

	^ withMakefile
]

{ #category : 'testing' }
IGHeaderGenerator >> includesNamespace: aString [

	^ self namespaces anySatisfy: [ :each | each cppName = aString ]
]

{ #category : 'initialization' }
IGHeaderGenerator >> initialize [

	super initialize.
	self withCBindings.
	self withoutMakefile.
	self withoutClasses.
	self withoutComments
]

{ #category : 'accessing' }
IGHeaderGenerator >> libraryClassName [
	"Pharo class name to store the wrapped functions"
	
	^ self fileReference basenameWithoutExtension capitalized
]

{ #category : 'accessing' }
IGHeaderGenerator >> libraryName [

	^ self cFileReference basenameWithoutExtension
]

{ #category : 'private' }
IGHeaderGenerator >> listElements [
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
IGHeaderGenerator >> makefileReference [
	
	^ FileLocator imageDirectory / 'Makefile'
]

{ #category : 'scripting' }
IGHeaderGenerator >> namespace: aNamespaceClass [

	namespaces ifNil: [ namespaces := #() ].
	namespaces := namespaces copyWith: aNamespaceClass
]

{ #category : 'accessing' }
IGHeaderGenerator >> namespaces [

	^ namespaces ifNil: [ #() ]
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> namespaces: aCollection [

	namespaces := aCollection
]

{ #category : 'accessing' }
IGHeaderGenerator >> prefix [

	^ prefix ifNil: [ prefix := self defaultPrefix ]
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> prefix: aPrefix [
	
	prefix := aPrefix
]

{ #category : 'generating' }
IGHeaderGenerator >> translateUnit [
	
	^ IGTranslatedUnit new
		generateFrom: self;
		yourself
]

{ #category : 'generating' }
IGHeaderGenerator >> translateUnitWithoutUnkown [
	
	^ IGTranslatedUnit new
		withoutUnknown;
		generateFrom: self;
		yourself
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> withCBindings [

	withCBindings := true
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> withClasses [

	withClasses := true
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> withComments [

	withComments := true
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> withMakefile [

	withMakefile := true
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> withoutCBindings [

	withCBindings := false
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> withoutClasses [

	withClasses := false
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> withoutComments [

	withComments := false
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> withoutMakefile [

	withMakefile := false
]
