Class {
	#name : 'IGHeaderFile',
	#superclass : 'Object',
	#instVars : [
		'includePaths',
		'fileReference',
		'withMakefile',
		'withCBindings',
		'withClasses',
		'libs'
	],
	#category : 'LibClang-IG',
	#package : 'LibClang-IG'
}

{ #category : 'private' }
IGHeaderFile >> addElement: current parent: parent to: elements [
	
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
IGHeaderFile >> addEnum: current parent: parent to: elements [
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
IGHeaderFile >> addEnumConstant: current parent: parent to: elements [
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
IGHeaderFile >> addFunction: current parent: parent to: elements [
	| parentElement func |
	
	func := IGFunction fromCursor: current.
	parentElement := self findParent: parent in: elements.
	parentElement 
		ifNotNil: [ parentElement addElement: func ]
		ifNil: [ elements add: func ]
]

{ #category : 'private' }
IGHeaderFile >> addNamespace: current to: elements [
	
	elements add: (IGNamespace fromCursor: current)
]

{ #category : 'private' }
IGHeaderFile >> addParameter: current parent: parent to: elements [
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
IGHeaderFile >> cFileReference [
	"where the wrapper functions will be placed"
	
	^ (FileLocator imageDirectory / (self fileReference basenameWithoutExtension, '_bindings')) withExtension: 'cpp'
]

{ #category : 'private' }
IGHeaderFile >> collectElements [
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
IGHeaderFile >> fileReference [
	"entry point, it has to point to an existing header file."
	
	^ fileReference
]

{ #category : 'accessing' }
IGHeaderFile >> fileReference: aReferenceOrString [
	
	fileReference := aReferenceOrString asFileReference
]

{ #category : 'private' }
IGHeaderFile >> findParent: parent in: elements [

	elements do: [ :each |
		(each findElementMatchingCursor: parent) 
			ifNotNil: [ :found | ^ found ] ].

	^ nil
]

{ #category : 'generating' }
IGHeaderFile >> generate [
	| elements |

	('Initiate generation of {1}' format: { self fileReference basename }) asBeaconSignal emit.
	'Collecting nodes' asBeaconSignal emit.
	elements := self collectElements.

	self hasCBindings ifTrue: [ self generateCBindingsWith: elements ].
	self hasMakefile ifTrue: [ self generateMakefile ].
	self hasClasses ifTrue: [ self generatePharoClassesWith: elements ]
]

{ #category : 'generating' }
IGHeaderFile >> generateCBindingsWith: elements [

	('Generating C file: {1}.' format: { self cFileReference basename }) asBeaconSignal emit.
	IGCVisitor new
		file: self;
		visitAll: elements
]

{ #category : 'generating' }
IGHeaderFile >> generateMakefile [
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
IGHeaderFile >> generatePharoClassesWith: elements [
	
	'Generating Pharo classes.' asBeaconSignal emit.
	IGClassVisitor new
		file: self;
		visitAll: elements
]

{ #category : 'testing' }
IGHeaderFile >> hasCBindings [

	^ withCBindings
]

{ #category : 'testing' }
IGHeaderFile >> hasClasses [

	^ withClasses
]

{ #category : 'testing' }
IGHeaderFile >> hasMakefile [

	^ withMakefile
]

{ #category : 'accessing' }
IGHeaderFile >> includePaths [
	"include paths to put in the include path (-I paramters) in clang, to make sure all 
	 dependencies are found."

	^ includePaths
]

{ #category : 'accessing' }
IGHeaderFile >> includePaths: aCollection [

	includePaths := aCollection
]

{ #category : 'private' }
IGHeaderFile >> includePathsAsArguments [

	^ self includePaths collect: [ :each | '-I', each ]
]

{ #category : 'initialization' }
IGHeaderFile >> initialize [

	super initialize.
	self withCBindings.
	self withoutMakefile.
	self withoutClasses
]

{ #category : 'accessing' }
IGHeaderFile >> libraryClassName [
	"Pharo class name to store the wrapped functions"
	
	^ self fileReference basenameWithoutExtension capitalized
]

{ #category : 'accessing' }
IGHeaderFile >> libs [

	^ libs
]

{ #category : 'accessing' }
IGHeaderFile >> libs: aCollection [

	libs := aCollection
]

{ #category : 'private' }
IGHeaderFile >> libsAsArguments [

	^ self libs collect: [ :each | '-l', each ]
]

{ #category : 'accessing' }
IGHeaderFile >> makefileReference [
	
	^ FileLocator imageDirectory / 'Makefile'
]

{ #category : 'accessing - configuration' }
IGHeaderFile >> withCBindings [

	withCBindings := true
]

{ #category : 'accessing - configuration' }
IGHeaderFile >> withClasses [

	withClasses := true
]

{ #category : 'accessing - configuration' }
IGHeaderFile >> withMakefile [

	withMakefile := true
]

{ #category : 'accessing - configuration' }
IGHeaderFile >> withoutCBindings [

	withCBindings := false
]

{ #category : 'accessing - configuration' }
IGHeaderFile >> withoutClasses [

	withClasses := false
]

{ #category : 'accessing - configuration' }
IGHeaderFile >> withoutMakefile [

	withMakefile := false
]
