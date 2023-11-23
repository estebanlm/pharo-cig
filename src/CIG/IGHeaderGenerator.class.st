Class {
	#name : 'IGHeaderGenerator',
	#superclass : 'Object',
	#instVars : [
		'includePaths',
		'fileReference',
		'withMakefile',
		'withCBindings',
		'withClasses',
		'libs'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'private' }
IGHeaderGenerator >> addElement: current parent: parent to: elements [
	
	current isNamespace 
		ifTrue: [ ^ self addNamespace: current to: elements ].
	current isFunctionDeclaration 
		ifTrue: [ ^ self addFunction: current parent: parent to: elements ].
	current isParameterDeclaration
		ifTrue: [ ^ self addParameter: current parent: parent to: elements ].
	current isEnumDeclaration
		ifTrue: [ ^ self addEnum: current parent: parent to: elements ].
	current isEnumConstantDeclaration
		ifTrue: [ ^ self addEnumConstant: current parent: parent to: elements ]		
]

{ #category : 'private' }
IGHeaderGenerator >> addEnum: current parent: parent to: elements [
	| parentElement enum |
	
	enum := IGEnum fromCursor: current.
	parentElement := self findParent: parent in: elements.
	parentElement 
		ifNotNil: [ 
			parentElement addEnum: enum ]
		ifNil: [
			elements add: enum ]
]

{ #category : 'private' }
IGHeaderGenerator >> addEnumConstant: current parent: parent to: elements [
	| parentElement enum |
	
	enum := IGEnumConstant fromCursor: current.
	parentElement := self findParent: parent in: elements.
	parentElement 
		ifNotNil: [
			parentElement addElement: enum ]
		ifNil: [
			self error: 'Should not happen.' ]
]

{ #category : 'private' }
IGHeaderGenerator >> addFunction: current parent: parent to: elements [
	| parentElement func |
	
	func := IGFunction fromCursor: current.
	parentElement := self findParent: parent in: elements.
	parentElement 
		ifNotNil: [ parentElement addElement: func ]
		ifNil: [ elements add: func ]
]

{ #category : 'private' }
IGHeaderGenerator >> addNamespace: current to: elements [
	
	elements add: (IGNamespace fromCursor: current)
]

{ #category : 'private' }
IGHeaderGenerator >> addParameter: current parent: parent to: elements [
	| parentElement parameter |

	parameter := IGParameter fromCursor: current.
	parentElement := self findParent: parent in: elements.
	parentElement 
		ifNotNil: [ 
			parentElement addParameter: parameter ]
		ifNil: [
			('Parameter parent {1} not found in node tree.' format: { parent kindSpelling }) asBeaconSignal emit ]
]

{ #category : 'accessing' }
IGHeaderGenerator >> cFileReference [
	"where the wrapper functions will be placed"
	
	^ (FileLocator imageDirectory / (self fileReference basenameWithoutExtension, '_bindings')) withExtension: 'cpp'
]

{ #category : 'private' }
IGHeaderGenerator >> collectElements [
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
	
	elements := Set new.
	cursor := tu cursor.
	cursor visitChildren: [ :current :parent :data |
		current location isInSystemHeader 
			ifFalse: [ self addElement: current parent: parent to: elements ].
		CXChildVisit recurse ].

	tu dispose.
	index dispose.
	
	^ elements
]

{ #category : 'accessing' }
IGHeaderGenerator >> fileReference [
	"entry point, it has to point to an existing header file."
	
	^ fileReference
]

{ #category : 'accessing' }
IGHeaderGenerator >> fileReference: aReferenceOrString [
	
	fileReference := aReferenceOrString asFileReference
]

{ #category : 'private' }
IGHeaderGenerator >> findParent: parent in: elements [

	elements do: [ :each |
		(each findElementMatchingCursor: parent) 
			ifNotNil: [ :found | ^ found ] ].

	^ nil
]

{ #category : 'generating' }
IGHeaderGenerator >> generate [
	| generated |

	('Initiate generation of {1}' format: { self fileReference basename }) asBeaconSignal emit.
	'Collecting nodes' asBeaconSignal emit.
	
	generated := self translateUnit.

	self hasCBindings ifTrue: [ self generateCBindingsWith: generated elements ].
	self hasMakefile ifTrue: [ self generateMakefile ].
	self hasClasses ifTrue: [ self generatePharoClassesWith: generated elements ]
]

{ #category : 'generating' }
IGHeaderGenerator >> generateCBindingsWith: elements [

	('Generating C file: {1}.' format: { self cFileReference basename }) asBeaconSignal emit.
	IGCVisitor new
		file: self;
		visitAll: elements
]

{ #category : 'generating' }
IGHeaderGenerator >> generateMakefile [
	| template |

	'Generating Makefile.' asBeaconSignal emit.

	template := '
INCLUDE_DIRS={2}
LIBS={3}

{1}.so: {1}.cpp
	clang -xc++ --shared $(INCLUDE_DIRS) $(LIBS) {1}.cpp -o {1}.so
' format: { 
	self cFileReference basenameWithoutExtension.
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
IGHeaderGenerator >> generatePharoClassesWith: elements [
	
	'Generating Pharo classes.' asBeaconSignal emit.
	IGClassVisitor new
		file: self;
		visitAll: elements
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

{ #category : 'initialization' }
IGHeaderGenerator >> initialize [

	super initialize.
	self withCBindings.
	self withoutMakefile.
	self withoutClasses
]

{ #category : 'accessing' }
IGHeaderGenerator >> libraryClassName [
	"Pharo class name to store the wrapped functions"
	
	^ self fileReference basenameWithoutExtension capitalized
]

{ #category : 'accessing' }
IGHeaderGenerator >> libs [

	^ libs
]

{ #category : 'accessing' }
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

{ #category : 'generating' }
IGHeaderGenerator >> translateUnit [
	
	^ IGTranslatedUnit new
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
IGHeaderGenerator >> withoutMakefile [

	withMakefile := false
]
