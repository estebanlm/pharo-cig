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
		'withComments'
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

{ #category : 'accessing' }
IGHeaderGenerator >> cFileReference [
	"where the wrapper functions will be placed"
	
	^ (FileLocator imageDirectory / (self bindingsName, '_bindings')) withExtension: 'cpp'
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
		self includePathsAsArguments asStringOn: s delimiter: ' ' ]).
	(String streamContents: [ :s | 
		self libsAsArguments asStringOn: s delimiter: ' ' ]) }.

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
IGHeaderGenerator >> hasMakefile [

	^ withMakefile
]

{ #category : 'accessing' }
IGHeaderGenerator >> includePaths [
	"include paths to put in the include path (-I paramters) in clang, to make sure all 
	 dependencies are found."

	^ includePaths
]

{ #category : 'accessing' }
IGHeaderGenerator >> includePaths: aCollection [

	includePaths := aCollection
]

{ #category : 'private' }
IGHeaderGenerator >> includePathsAsArguments [

	^ self includePaths collect: [ :each | '-I', each ]
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

{ #category : 'accessing' }
IGHeaderGenerator >> libs [

	^ libs
]

{ #category : 'accessing - configuration' }
IGHeaderGenerator >> libs: aCollection [

	libs := aCollection
]

{ #category : 'private' }
IGHeaderGenerator >> libsAsArguments [

	^ self libs collect: [ :each | '-l', each ]
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
			self includePathsAsArguments.
	
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
