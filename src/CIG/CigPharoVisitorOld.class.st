Class {
	#name : 'CigPharoVisitorOld',
	#superclass : 'CigVisitor',
	#instVars : [
		'generator',
		'types',
		'structures'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'private - adding' }
CigPharoVisitorOld >> addCPPHeaderTo: aNamespaceClass [
	| template |
	
	template := ('cppHeader

	^ ''{1}''' format: { self file bindingsName, '_bindings.h' }).

	aNamespaceClass class 
		compile: template
		classified: 'accessing'
]

{ #category : 'private - adding' }
CigPharoVisitorOld >> addCPPName: aString to: aNamespaceClass [
	| template |
	
	template := ('cppName

	^ ''{1}''' format: { aString }).

	aNamespaceClass class 
		compile: template
		classified: 'accessing'
]

{ #category : 'private - adding' }
CigPharoVisitorOld >> addClass: aName extends: aClass tag: aTag [
	| builder |
	
	builder := aClass << aName asSymbol.
	
	(aClass package name = self packageName) ifFalse: [  
		builder
			traits: self libraryTrait;
			sharedPools: (
				{ self typesName asSymbol }, 
				(self file namespaces 
					collect: [ :each | each typedef name ]
					as: Set)
					asArray) ].
	
	^ builder
		tag: aTag;
		package: self packageName;
		install
]

{ #category : 'private - adding' }
CigPharoVisitorOld >> addFFILibrary: aUnit [
	| ffiLibraryName class template |

	ffiLibraryName := self libraryName.
	
	class := FFILibrary << ffiLibraryName asSymbol
		tag: 'Library';
		package: self packageName;
		install.	

	template := (('unix64LibraryName

	^ FFIUnix64LibraryFinder findLibrary: ''{1}.so''')
	format: { self file libraryName }).
		
	class 
		compile: template
		classified: 'accessing - platform'
]

{ #category : 'private - adding' }
CigPharoVisitorOld >> addFFITrait: aUnit [
	| ffiTraitName ffiLibraryName trait template |

	ffiLibraryName := self libraryName.
	ffiTraitName := self libraryTraitName.
	
	trait := Trait << ffiTraitName asSymbol
		tag: 'Library';
		package: self packageName;
		install.	

	template := (('ffiLibraryName

	^ {1}')
	format: { ffiLibraryName }).
		
	trait compile: template classified: 'library path'.
	trait class compile: template classified: 'library path'
]

{ #category : 'private - adding' }
CigPharoVisitorOld >> addTypedefTo: aNamespaceClass [
	| template |
	
	template := ('typedef

	^ {1}' format: { self typesName }).

	aNamespaceClass class 
		compile: template
		classified: 'typedef'
]

{ #category : 'private - adding' }
CigPharoVisitorOld >> addTypes: aUnit [
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

{ #category : 'private - adding' }
CigPharoVisitorOld >> addTypesClass: aUnit [
	| typesName |

	typesName := self typesName.
	SharedPool << typesName asSymbol
		tag: 'Library';
		package: self packageName;
		install
]

{ #category : 'private' }
CigPharoVisitorOld >> classFor: aSymbol [
	
	^ self class environment at: aSymbol asSymbol
]

{ #category : 'private - accessing' }
CigPharoVisitorOld >> libraryName [

	^ 'Lib', self file bindingsName capitalized
]

{ #category : 'private - accessing' }
CigPharoVisitorOld >> libraryTrait [
		
	^ self class environment at: (self libraryTraitName asSymbol)
]

{ #category : 'private - accessing' }
CigPharoVisitorOld >> libraryTraitName [

	^ 'LibT', self file bindingsName capitalized
]

{ #category : 'private' }
CigPharoVisitorOld >> namespaceFor: aNode [
	| current |
	
	current := aNode.
	[ current notNil ] 
	whileTrue: [ 
		current isNamespace ifTrue: [ ^ current ].
		current := current parent ].
	^ nil
]

{ #category : 'private' }
CigPharoVisitorOld >> namespaceForClass: aClass [

	^ (self namespaceFor: aClass) 
		ifNotNil: [ :aNamespace | aNamespace basename capitalized ]
		ifNil: [ 'Library' ]
]

{ #category : 'private' }
CigPharoVisitorOld >> namespaceForEnum: anEnum [

	^ (self namespaceFor: anEnum) 
		ifNotNil: [ :aNamespace | aNamespace basename capitalized ]
		ifNil: [ 'Library' ]
]

{ #category : 'private' }
CigPharoVisitorOld >> namespaceForStructure: aStructure [

	^ self namespaceForEnum: aStructure
]

{ #category : 'private - accessing' }
CigPharoVisitorOld >> packageName [

	^ 'Lib', self file bindingsName capitalized
]

{ #category : 'private - accessing' }
CigPharoVisitorOld >> prefix [
	
	^ self file prefix
]

{ #category : 'private' }
CigPharoVisitorOld >> registerAllTypesIfNeeded: aCollection [

	aCollection 
		select: [ :each | each hasTypeReference and: [ each typeReference isUnknownReference not ] ]
		thenDo: [ :each | 
			self 
				registerDeclaration: each cDeclaration
				as: (each phDeclarationWith: self prefix) ]
]

{ #category : 'private' }
CigPharoVisitorOld >> registerDeclaration: aString as: otherString [

	types 
		at: ((aString endsWith: '*')
			ifTrue: [ aString allButLast ]
			ifFalse: [ aString ])
		put: otherString
]

{ #category : 'private' }
CigPharoVisitorOld >> registerType: aNode [

	self 
		registerDeclaration: aNode cDeclaration 
		as: (aNode phDeclarationWith: self prefix)
]

{ #category : 'private' }
CigPharoVisitorOld >> superclassFor: aClass [
	| superclass |

	superclass := aClass superclass ifNil: [ ^ FFIOpaqueObject ].
	^ superclass reference 
		ifNotNil: [ :ref | self classFor: (ref phDeclarationWith: self prefix) ]
		ifNil: [ FFIOpaqueObject ]
]

{ #category : 'private' }
CigPharoVisitorOld >> types [

	^ types
]

{ #category : 'private - adding' }
CigPharoVisitorOld >> typesClass [

	^ self class environment at: self typesName asSymbol
]

{ #category : 'private - adding' }
CigPharoVisitorOld >> typesName [

	^ self prefix, self file bindingsName capitalized, 'Typedef'
]

{ #category : 'visiting' }
CigPharoVisitorOld >> visitClass: aClass [
	| class |

	self registerType: aClass.
	class := self 
		addClass: (aClass phDeclarationWith: self prefix) 
		extends: (self superclassFor: aClass)
		tag: (self namespaceForClass: aClass).
	self visitAll: aClass elements.
	self file hasComments ifTrue: [ class comment: aClass comment ].
	aClass isAbstract ifFalse: [ 
		(CigPharoGeneratorOld on: self) 
			generateDispose: aClass;
			generateFinalize: aClass;
			generateAutoRelease: aClass ]
]

{ #category : 'visiting' }
CigPharoVisitorOld >> visitConstructor: aConstructor [

	(CigPharoGeneratorOld on: self) 
		generateConstructor: aConstructor;
		generateCreator: aConstructor
]

{ #category : 'visiting' }
CigPharoVisitorOld >> visitEnum: anEnum [
	| enum template |

	self registerType: anEnum.
	
	enum := self 
		addClass: (anEnum phDeclarationWith: self prefix) 
		extends: FFIEnumeration
		tag: (self namespaceForEnum: anEnum).

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
CigPharoVisitorOld >> visitFunction: aFunction [

	"add function to associated namespace or to main library if no namespace provided"
	(CigPharoGeneratorOld on: self) generateFunction: aFunction
]

{ #category : 'visiting' }
CigPharoVisitorOld >> visitMethod: aMethod [

	(aMethod isPublic not 
		or: [ aMethod isOperator ]) 
		ifTrue: [ ^ self ].

	(CigPharoGeneratorOld on: self) generateMethod: aMethod
]

{ #category : 'visiting' }
CigPharoVisitorOld >> visitNamespace: aNamespace [
	| namespace |

	(self includesNamespace: aNamespace cppDeclaration) ifTrue: [
		self visitAll: (aNamespace elements select: [ :each | each isNamespace ]). 
		 ^ self ].

	namespace := self 
		addClass: (aNamespace phDeclarationWith: self prefix) 
		extends: Object
		tag: aNamespace basename capitalized.
	self visitAll: aNamespace elements.
	self addCPPName: aNamespace cppDeclaration to: namespace.
	self addCPPHeaderTo: namespace.
	self addTypedefTo: namespace
]

{ #category : 'visiting' }
CigPharoVisitorOld >> visitStructure: aStructure [
	| struct template |

	self registerType: aStructure.
	self registerAllTypesIfNeeded: (aStructure fields collect: [ :each | each resolveType ]).
	
	struct := self 
		addClass: (aStructure phDeclarationWith: self prefix) 
		extends: FFIStructure
		tag: (self namespaceForStructure: aStructure).

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
		
	structures add: struct
]

{ #category : 'visiting' }
CigPharoVisitorOld >> visitTypedef: aTypedef [
	| type |

	type := aTypedef resolveType.
	types 
		at: aTypedef cDeclaration
		put: (type phDeclarationWith: self prefix)
]

{ #category : 'visiting' }
CigPharoVisitorOld >> visitUnit: aUnit [

	self addFFILibrary: aUnit.
	self addFFITrait: aUnit.
	self addTypesClass: aUnit. 
	types := Dictionary new.
	structures := OrderedCollection new.
	self visitAll: aUnit elements.
	self addTypes: aUnit.
	
	structures do: #rebuildFieldAccessors 
]