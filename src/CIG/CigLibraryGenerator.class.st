"
This is a generator of C bindings for CPP libraries. 
It takes the declaring header (plus some configuration files) and is capable of generate the corresponfing C bindings file, an associated Makefile and also all the Pharo classes included.

## Example

```

(noise := CigLibraryGenerator new)
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
		'withClasses',
		'libs',
		'prefix',
		'bindingsName',
		'namespaces',
		'defines',
		'definesBeforeHeader',
		'excluding',
		'ffiRunner',
		'typedefs'
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

{ #category : 'accessing' }
CigLibraryGenerator >> bindingsName [

	^ bindingsName
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

{ #category : 'accessing - scripting' }
CigLibraryGenerator >> cTypedef: aDeclaration as: aName [
	"a typedef will be added to the library at the begining, making it easy to bypass certain types
	 without adding the while library."

	typedefs ifNil: [ typedefs := OrderedCollection new ].
	typedefs add: aDeclaration -> aName
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> cTypedefs [

	^ typedefs
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> cTypedefs: anOrderedDictionary [

	typedefs := anOrderedDictionary
]

{ #category : 'private' }
CigLibraryGenerator >> defaultPrefix [

	^ self bindingsName 
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
		ifAbsentPut: [ CigImportTarget newName: aString ])
		import: aCollection
]

{ #category : 'generating' }
CigLibraryGenerator >> generate [
	
	self subclassResponsibility
]

{ #category : 'private - generating' }
CigLibraryGenerator >> generatePharoClassesWith: aUnit [
	
	'Generating Pharo classes.' asBeaconSignal emit.
	CigPharoVisitor new
		file: self;
		visit: aUnit
]

{ #category : 'testing' }
CigLibraryGenerator >> hasClasses [

	^ withClasses
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> import: aString [

	(imports 
		at: aString
		ifAbsentPut: [ CigImportTarget newName: aString ])
		importAll
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
	self withClasses.
	self useSameThread
]

{ #category : 'accessing' }
CigLibraryGenerator >> libraryClassName [
	"Pharo class name to store the wrapped functions"
	
	^ self bindingsName basenameWithoutExtension capitalized
]

{ #category : 'accessing' }
CigLibraryGenerator >> libraryName [

	^ self subclassResponsibility
]

{ #category : 'utilies' }
CigLibraryGenerator >> listElements [
	"makes a tree of elements I can use to generate the wrapper file and classes."

	^ self newTranslatedUnit listElementsFrom: self
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
CigLibraryGenerator >> translateUnitWithoutUnkown [
	
	^ self newTranslatedUnit
		withoutUnknown;
		generateFrom: self;
		yourself
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
CigLibraryGenerator >> withClasses [

	withClasses := true
]

{ #category : 'accessing - configuration' }
CigLibraryGenerator >> withoutClasses [

	withClasses := false
]
