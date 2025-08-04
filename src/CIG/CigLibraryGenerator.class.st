"
This is a generator of C bindings for CPP libraries. 
It takes the declaring header (plus some configuration files) and is capable of generate the corresponfing C bindings file, an associated Makefile and also all the Pharo classes included.

## Example

```

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
```
"
Class {
	#name : 'CigLibraryGenerator',
	#superclass : 'Object',
	#instVars : [
		'imports',
		'includePaths',
		'excludePaths',
		'withClasses',
		'libs',
		'prefix',
		'namespaces',
		'defines',
		'definesBeforeHeader',
		'excluding',
		'ffiRunner',
		'typedefs',
		'libraryName',
		'unixLibraryName',
		'macLibraryName',
		'winLibraryName',
		'packageName',
		'nameGenerator',
		'withBaseline',
		'variadics',
		'withConstants',
		'constantGenerator'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'translating' }
CigLibraryGenerator class >> translateUnit: aFileName [

	^ self new 
		file: aFileName;
		translateUnit
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

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> cExcludePath: aStringOrReference [
	"exclude headers within a specific path. 
	 This is usually /usr/include (because is too much), but not always"

	excludePaths ifNil: [ excludePaths := #() ].
	excludePaths := excludePaths copyWith: (self normalizeIncludePath: aStringOrReference)
]

{ #category : 'accessing' }
CigLibraryGenerator >> cExcludePaths [
	"exclude paths to discard in the unit generation."

	^ excludePaths ifNil: [ #() ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> cExcludePaths: aCollection [
	"List of paths to be exluded from parsing. 
	 This is to be excluded on the unit generation. 
	 E.g. I can exclude /usr/include but include /usr/include/something.h"

	excludePaths := aCollection
]

{ #category : 'accessing' }
CigLibraryGenerator >> cFileReference [
	"where the wrapper functions will be placed"
	
	^ (FileLocator imageDirectory 
		/ 'CIG' 
		/ self libraryName 
		/ (self libraryName, '_bindings')) 
		withExtension: 'cpp'
]

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> cIncludePath: aStringOrReference [
	"include this path in the clang parser. 
	 This is the equivallent to the -I parameter"

	includePaths ifNil: [ includePaths := #() ].
	includePaths := includePaths copyWith: (self normalizeIncludePath: aStringOrReference)
]

{ #category : 'accessing' }
CigLibraryGenerator >> cIncludePaths [
	"include paths to put in the include path (-I paramters) in clang, to make sure all 
	 dependencies are found."

	^ includePaths ifNil: [ #() ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> cIncludePaths: aCollection [
	"include this collection of paths in the clang parser. 
	 This is the equivallent to the -I parameter"

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

	^ libs ifNil: [ #() ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> cLibs: aCollection [

	libs := aCollection
]

{ #category : 'private' }
CigLibraryGenerator >> cLibsAsArguments [

	^ self cLibs collect: [ :each | '-l', each ]
]

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> cTypedef: aDeclaration as: aName [
	"a typedef will be added to the library at the begining, making it easy to bypass certain types
	 without adding the while library."

	typedefs ifNil: [ typedefs := #() ].
	typedefs := typedefs copyWith: aDeclaration -> aName
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> cTypedefs [

	^ typedefs
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> cTypedefs: aCollectionOfAssociations [
	"receives a collection of asociation typeToDefine->definition. 
	 e.g. { #myInt -> #int } "

	typedefs := aCollectionOfAssociations
]

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> cVariadic: functionDeclaration as: aSelector [
	"declare a variadic to be added to the function declaration.
	 e.g. 
	 lib cVariadic: 'int printf(char *fmt, long value)' as: #printf:long: "

	variadics ifNil: [ variadics := OrderedDictionary new ].
	variadics at: aSelector put: functionDeclaration
]

{ #category : 'accessing' }
CigLibraryGenerator >> constantGenerator [

	^ constantGenerator ifNil: [ constantGenerator := CigConstantGenerator new ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> constantGenerator: aConstantGenerator [
	"Set the object that will be used to generate constants.
	 The default will be a `CigConstantGenerator` instance, but users can provide their 
	 own resolvers (Or configure the provided default)."
	 
	self withConstants.
	constantGenerator := aConstantGenerator
]

{ #category : 'private' }
CigLibraryGenerator >> defaultPrefix [

	^ self libraryName 
		ifNotNil: [ :aName | (aName first: 2) capitalized ]
		ifNil: [ '' ]
]

{ #category : 'utilies' }
CigLibraryGenerator >> diagnostics [
	"makes a tree of elements I can use to generate the wrapper file and classes."

	^ self newTranslatedUnit diagnosticsFrom: self
]

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> exclude: aString [

	excluding ifNil: [ excluding := #() ].
	excluding := excluding copyWith: aString
]

{ #category : 'accessing' }
CigLibraryGenerator >> excluding [

	^ excluding ifNil: [ #() ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> excluding: aCollection [
	"a list of elements that will be excluded from generation (it will not be visible 
	 by Pharo). 
	 aCollection is a list of strings with cppDeclaration of elements. 
	 e.g. 'finalcut::FString::begin' (the method begin)"
	
	excluding := aCollection
]

{ #category : 'accessing' }
CigLibraryGenerator >> ffiRunner [

	^ ffiRunner
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> from: aString import: aCollection [

	(imports 
		at: aString
		ifAbsentPut: [ CigImportTargetFile newName: aString ])
		import: aCollection
]

{ #category : 'generating' }
CigLibraryGenerator >> generate [
	
	self subclassResponsibility
]

{ #category : 'private - generating' }
CigLibraryGenerator >> generatePharoBaselineWith: aUnit [
	| baselineName baselineClass |
		
	baselineName := 'BaselineOf', self packageName.
	logger trace: baselineName.
	baselineClass := BaselineOf << baselineName asSymbol
		package: baselineName;
		install.
		
	baselineClass compile: 'baseline: spec
	<baseline>
	
	spec for: #common do: [
		spec package: ''', self packageName, ''' 
	]'
	classified: 'baselines'
]

{ #category : 'private - generating' }
CigLibraryGenerator >> generatePharoClassesWith: aUnit [
	
	logger trace.
	CigPharoVisitor new
		file: self;
		visit: aUnit
]

{ #category : 'testing' }
CigLibraryGenerator >> hasBaseline [
	
	^ withBaseline
]

{ #category : 'testing' }
CigLibraryGenerator >> hasClasses [

	^ withClasses
]

{ #category : 'testing' }
CigLibraryGenerator >> hasConstants [

	^ withConstants
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> import: aString [

	(imports 
		at: aString
		ifAbsentPut: [ CigImportTargetFile newName: aString ])
		importAll
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> importUnit: aString [
	| unitName count |

	count := (self imports select: [ :each | each isUnit ]) size.
	unitName := '{1}_{2}.h' format: { self prefix asLowercase. count }.
	(imports 
		at: UUID new asString
		ifAbsentPut: [ CigImportTargetUnit newName: unitName ])
		import: aString
]

{ #category : 'accessing' }
CigLibraryGenerator >> imports [

	^ imports
]

{ #category : 'testing' }
CigLibraryGenerator >> includesNamespace: aString [

	^ self namespaces anySatisfy: [ :each | each cppName = aString ]
]

{ #category : 'initialization' }
CigLibraryGenerator >> initialize [

	super initialize.
	imports := Dictionary new.

	self withBaseline.
	self withClasses.
	self withConstants.
	self useSameThread
]

{ #category : 'accessing' }
CigLibraryGenerator >> libraryClassName [
	"Pharo class name to store the wrapped functions"
	
	^ self libraryName basenameWithoutExtension capitalized
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> libraryName [

	^ libraryName
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> libraryName: aName [

	libraryName := aName
]

{ #category : 'utilies' }
CigLibraryGenerator >> listElements [
	"makes a tree of elements I can use to generate the wrapper file and classes."

	^ self newTranslatedUnit listElementsFrom: self
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> macLibraryName [

	^ macLibraryName ifNil: [ 'lib', self libraryName, '.dylib' ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> macLibraryName: aString [

	macLibraryName := aString
]

{ #category : 'accessing' }
CigLibraryGenerator >> nameGenerator [

	^ nameGenerator
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> nameGenerator: aNameGenerator [
	"Set the visitor that will be used to resolve the name the elements have.
	 The default will be a `CigNameGenerator` instance, but users can provide their 
	 own resolvers (Or configure the provided default)."

	nameGenerator := aNameGenerator
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

{ #category : 'private' }
CigLibraryGenerator >> newTranslatedUnit [

	^ self subclassResponsibility
]

{ #category : 'private' }
CigLibraryGenerator >> normalizeIncludePath: aStringOrReference [
	
	(aStringOrReference isString and: [ aStringOrReference beginsWith: '.' ])
		ifTrue: [ ^ aStringOrReference ].
	^ aStringOrReference asFileReference fullName
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> packageName [
	"answer name of the package where the generated classes will be placed"

	^ packageName ifNil: [ 
		packageName :='Lib', self libraryName capitalized ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> packageName: aName [
	"name of the package where the generated classes will be placed"
	
	packageName := aName
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
	
	^ self newTranslatedUnit
		generateFrom: self;
		yourself
]

{ #category : 'generating' }
CigLibraryGenerator >> translateUnitWithoutUnknown [
	
	^ self newTranslatedUnit
		withoutUnknown;
		generateFrom: self;
		yourself
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> unixLibraryName [

	^ unixLibraryName ifNil: [ 'lib', self libraryName, '.so' ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> unixLibraryName: aString [

	unixLibraryName := aString
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> useMainThread [

	ffiRunner := CigFFIRunnerMainThread new 
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> useSameThread [

	ffiRunner := CigFFIRunnerSameThread new 
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> useWorkerThread [

	self useWorkerThreadNamed: self packageName
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> useWorkerThreadNamed: aString [

	ffiRunner := CigFFIRunnerWorkerThread new 
		workerName: aString;
		yourself
]

{ #category : 'accessing' }
CigLibraryGenerator >> variadics [
	"Since Pharo do not have variadic functions, we cannot parse them from sources. 
	 The variarics list can be used to add variadic declarations that will be added 
	 as regular function calls.
	 The variadics arguments is an array of associations of the form 
	 	C Function declaration -> Selector. 
	 e.g.  'int printf(char *fmt, long number)' -> #printf:long:"

	^ variadics ifNil: [ OrderedDictionary new ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> variadics: aDictionary [
	"Since Pharo do not have variadic functions, we cannot parse them from sources. 
	 The variarics list can be used to add variadic declarations that will be added 
	 as regular function calls.
	 The variadics arguments is dictionary of the form C Function -> Selector. 
	 e.g.  'int printf(char *fmt, long number)' -> #printf:long:"

	variadics := aDictionary asDictionary
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> winLibraryName [

	^ winLibraryName ifNil: [ self libraryName, '.dll' ]
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> winLibraryName: aString [

	winLibraryName := aString
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withBaseline [

	withBaseline := true
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withClasses [

	withClasses := true
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withConstants [
	"Indicate the generator you want to generate a SharedPool named `LibraryNameConstants` 
	 containing all the macro definitions we are able to parse (which is not ALL of them, 
	 but it should be most of them).
	 This does not includes function-like macros.
	 DEFAULT: true"

	withConstants := true
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withoutBaseline [

	withBaseline := false
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withoutClasses [

	withClasses := false
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withoutConstants [

	withConstants := false
]
