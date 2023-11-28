Class {
	#name : 'IGPharoVisitor',
	#superclass : 'IGVisitor',
	#instVars : [
		'generator',
		'types'
	],
	#category : 'CIG-Generate-Pharo',
	#package : 'CIG',
	#tag : 'Generate-Pharo'
}

{ #category : 'private' }
IGPharoVisitor >> addClass: aName extends: aClass [
	| builder |
	
	builder := aClass << aName asSymbol.
	
	(aClass package name = self packageName) ifFalse: [  
		builder
			traits: self libraryTrait;
			sharedPools: { self typesName asSymbol } ].
	
	^ builder
		package: self packageName;
		install
]

{ #category : 'private' }
IGPharoVisitor >> addFFILibrary: aUnit [
	| ffiLibraryName ffiClass template |

	ffiLibraryName := self libraryName.
	
	ffiClass := FFILibrary << ffiLibraryName asSymbol
		package: self packageName;
		install.	

	template := (('unix64LibraryName

	^ FFIUnix64LibraryFinder findLibrary: ''{1}.so''')
	format: { self file libraryName }).
		
	ffiClass 
		compile: template
		classified: 'accessing - platform'
]

{ #category : 'private' }
IGPharoVisitor >> addFFITrait: aUnit [
	| ffiTraitName ffiLibraryName ffiTrait template |

	ffiLibraryName := self libraryName.
	ffiTraitName := self libraryTraitName.
	
	ffiTrait := Trait << ffiTraitName asSymbol
		package: self packageName;
		install.	

	template := (('ffiLibraryName

	^ {1}')
	format: { ffiLibraryName }).
		
	ffiTrait compile: template classified: 'library path'.
	ffiTrait class compile: template classified: 'library path'
]

{ #category : 'private' }
IGPharoVisitor >> addTypes: aUnit [
	| class template |
	
	class := SharedPool << self typesName asSymbol
		sharedVariables: (types keys collect: #asSymbol as: Array);
		install.

	template := String streamContents: [ :stream |
		stream << 'initialize' << String cr << String cr.
		types associations 
			do: [ :assoc | stream <<  String tab <<  assoc key << ' := ' << assoc value ]
			separatedBy: [ stream << '.' << String cr ] ].
	
	class class compile: template classified: 'class initialization'.
	
	class initialize		
	
]

{ #category : 'private' }
IGPharoVisitor >> addTypesClass: aUnit [
	| typesName |

	typesName := self typesName.
	SharedPool << typesName asSymbol
		package: self packageName;
		install
]

{ #category : 'private' }
IGPharoVisitor >> classFor: aSymbol [
	
	^ self class environment at: aSymbol asSymbol
]

{ #category : 'enum declaration' }
IGPharoVisitor >> enumDecl [

	^ #(		
    QUALITY_FAST 0
    QUALITY_STD 1
    QUALITY_BEST 2 )
]

{ #category : 'private' }
IGPharoVisitor >> libraryName [

	^ 'Lib', self file bindingsName capitalized
]

{ #category : 'private' }
IGPharoVisitor >> libraryTrait [
		
	^ self class environment at: (self libraryTraitName asSymbol)
]

{ #category : 'private' }
IGPharoVisitor >> libraryTraitName [

	^ 'LibT', self file bindingsName capitalized
]

{ #category : 'private' }
IGPharoVisitor >> packageName [

	^ 'Lib', self file bindingsName capitalized
]

{ #category : 'tests - printing' }
IGPharoVisitor >> prefix [
	
	^ self file prefix
]

{ #category : 'private' }
IGPharoVisitor >> registerType: aNode [

	types 
		at: aNode cDeclaration 
		put: (aNode phDeclarationWith: self prefix)
]

{ #category : 'private' }
IGPharoVisitor >> superclassFor: aClass [
	| superclass |

	superclass := aClass superclass ifNil: [ ^ FFIOpaqueObject ].
	^ superclass reference 
		ifNotNil: [ :ref | self classFor: (ref phDeclarationWith: self prefix) ]
		ifNil: [ FFIOpaqueObject ]
]

{ #category : 'private' }
IGPharoVisitor >> typesClass [

	^ self class environment at: self typesName asSymbol
]

{ #category : 'private' }
IGPharoVisitor >> typesName [

	^ self prefix, self file bindingsName capitalized, 'Types'
]

{ #category : 'visiting' }
IGPharoVisitor >> visitClass: aClass [

	self registerType: aClass.
	self 
		addClass: (aClass phDeclarationWith: self prefix) 
		extends: (self superclassFor: aClass).
	self visitAll: aClass elements
]

{ #category : 'visiting' }
IGPharoVisitor >> visitConstructor: aConstructor [

	(IGPharoGenerator on: self) 
		generateConstructor: aConstructor;
		generateCreator: aConstructor
]

{ #category : 'visiting' }
IGPharoVisitor >> visitEnum: anEnum [
	| enum template |

	self registerType: anEnum.
	
	enum := self addClass: (anEnum phDeclarationWith: self prefix) extends: FFIEnumeration.

	template := String streamContents: [ :stream |
		stream << 'enumDecl

	^ #(		
'.
		anEnum elements 
			do: [ :each | stream << '    ' << each name << ' ' << each value asString ]
			separatedBy: [ stream cr ].
		stream <<  ' )'].
	
	enum class
		compile: template
		classified: 'enum declaration'.
		
	enum 
		initializeEnumeration;
		rebuildEnumAccessors
]

{ #category : 'visiting' }
IGPharoVisitor >> visitFunction: aFunction [

	"add function to associated namespace or to main library if no namespace provided"
	(IGPharoGenerator on: self) generateFunction: aFunction
]

{ #category : 'visiting' }
IGPharoVisitor >> visitMethod: aMethod [

	(aMethod isPublic not 
		or: [ aMethod isOperator ]) 
		ifTrue: [ ^ self ].

	(IGPharoGenerator on: self) generateMethod: aMethod
]

{ #category : 'visiting' }
IGPharoVisitor >> visitNamespace: aNamespace [
	| class |

	"do not do anything, but prepare to add a class in case there are associated functions"
	class := self addClass: (aNamespace phDeclarationWith: self prefix) extends: Object.
	self visitAll: aNamespace elements
]

{ #category : 'visiting' }
IGPharoVisitor >> visitStructure: aStructure [
	| struct template |

	self registerType: aStructure.
	
	struct := self addClass: (aStructure phDeclarationWith: self prefix) extends: FFIStructure.

	template := String streamContents: [ :stream |
		stream << 'fieldsDesc' << String cr << String cr. 
		stream << String tab << '^ #(' << String cr.
		aStructure fields 
			do: [ :each | 
				stream 
					<< String tab << String tab 
					<< each resolveType cDeclarationForFFI 
					<< ' ' 
					<< each name ]
			separatedBy: [ stream << ';' << String cr ].
		stream << ' )' ]. 

	struct class 
		compile: template
		classified: 'fields - definition'.
		
	struct rebuildFieldAccessors 
]

{ #category : 'visiting' }
IGPharoVisitor >> visitUnit: aUnit [

	self addFFILibrary: aUnit.
	self addFFITrait: aUnit.
	self addTypesClass: aUnit. 
	types := Dictionary new.
	self visitAll: aUnit elements.
	self addTypes: aUnit
]
