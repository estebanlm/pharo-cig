Class {
	#name : 'CigPharoVisitor',
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
CigPharoVisitor >> addCPPHeaderTo: aNamespaceClass [
	| template |
	
	template := ('cppHeader

	^ ''{1}''' format: { self file bindingsName, '_bindings.h' }).

	aNamespaceClass class 
		compile: template
		classified: 'accessing'
]

{ #category : 'private - adding' }
CigPharoVisitor >> addCPPName: aString to: aNamespaceClass [
	| template |
	
	template := ('cppName

	^ ''{1}''' format: { aString }).

	aNamespaceClass class 
		compile: template
		classified: 'accessing'
]

{ #category : 'private - adding' }
CigPharoVisitor >> addClass: aName extends: aClass tag: aTag [
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
CigPharoVisitor >> addFFILibrary: aUnit [
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
CigPharoVisitor >> addFFITrait: aUnit [
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
CigPharoVisitor >> addTypedefTo: aNamespaceClass [
	| template |
	
	template := ('typedef

	^ {1}' format: { self typesName }).

	aNamespaceClass class 
		compile: template
		classified: 'typedef'
]

{ #category : 'private - adding' }
CigPharoVisitor >> addTypes: aUnit [
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
CigPharoVisitor >> addTypesClass: aUnit [
	| typesName |

	typesName := self typesName.
	SharedPool << typesName asSymbol
		tag: 'Library';
		package: self packageName;
		install
]

{ #category : 'private' }
CigPharoVisitor >> classFor: aSymbol [
	
	^ self class environment at: aSymbol asSymbol
]

{ #category : 'private - accessing' }
CigPharoVisitor >> libraryName [

	^ 'Lib', self file bindingsName capitalized
]

{ #category : 'private - accessing' }
CigPharoVisitor >> libraryTrait [
		
	^ self class environment at: (self libraryTraitName asSymbol)
]

{ #category : 'private - accessing' }
CigPharoVisitor >> libraryTraitName [

	^ 'LibT', self file bindingsName capitalized
]

{ #category : 'private' }
CigPharoVisitor >> namespaceFor: aNode [
	| current |
	
	current := aNode.
	[ current notNil ] 
	whileTrue: [ 
		current isNamespace ifTrue: [ ^ current ].
		current := current parent ].
	^ nil
]

{ #category : 'private' }
CigPharoVisitor >> namespaceForClass: aClass [

	^ (self namespaceFor: aClass) 
		ifNotNil: [ :aNamespace | aNamespace basename capitalized ]
		ifNil: [ 'Library' ]
]

{ #category : 'private' }
CigPharoVisitor >> namespaceForEnum: anEnum [

	^ (self namespaceFor: anEnum) 
		ifNotNil: [ :aNamespace | aNamespace basename capitalized ]
		ifNil: [ 'Library' ]
]

{ #category : 'private' }
CigPharoVisitor >> namespaceForStructure: aStructure [

	^ self namespaceForEnum: aStructure
]

{ #category : 'private - accessing' }
CigPharoVisitor >> packageName [

	^ 'Lib', self file bindingsName capitalized
]

{ #category : 'private - accessing' }
CigPharoVisitor >> prefix [
	
	^ self file prefix
]

{ #category : 'private' }
CigPharoVisitor >> registerAllTypesIfNeeded: aCollection [

	aCollection 
		select: [ :each | each hasTypeReference and: [ each typeReference isUnknownReference not ] ]
		thenDo: [ :each | 
			self 
				registerDeclaration: each cDeclaration
				as: (each phDeclarationWith: self prefix) ]
]

{ #category : 'private' }
CigPharoVisitor >> registerDeclaration: aString as: otherString [

	types 
		at: ((aString endsWith: '*')
			ifTrue: [ aString allButLast ]
			ifFalse: [ aString ])
		put: otherString
]

{ #category : 'private' }
CigPharoVisitor >> registerType: aNode [

	self 
		registerDeclaration: aNode cDeclaration 
		as: (aNode phDeclarationWith: self prefix)
]

{ #category : 'private' }
CigPharoVisitor >> superclassFor: aClass [
	| superclass |

	superclass := aClass superclass ifNil: [ ^ FFIOpaqueObject ].
	^ superclass reference 
		ifNotNil: [ :ref | self classFor: (ref phDeclarationWith: self prefix) ]
		ifNil: [ FFIOpaqueObject ]
]

{ #category : 'private' }
CigPharoVisitor >> types [

	^ types
]

{ #category : 'private - adding' }
CigPharoVisitor >> typesClass [

	^ self class environment at: self typesName asSymbol
]

{ #category : 'private - adding' }
CigPharoVisitor >> typesName [

	^ self prefix, self file bindingsName capitalized, 'Typedef'
]

{ #category : 'visiting' }
CigPharoVisitor >> visitClass: aClass [
	| class |

	self registerType: aClass.
	class := self 
		addClass: (aClass phDeclarationWith: self prefix) 
		extends: (self superclassFor: aClass)
		tag: (self namespaceForClass: aClass).
	self visitAll: aClass elements.
	self file hasComments ifTrue: [ class comment: aClass comment ].
	aClass isAbstract ifFalse: [ 
		(CigPharoGenerator on: self) 
			generateDispose: aClass;
			generateFinalize: aClass;
			generateAutoRelease: aClass ]
]

{ #category : 'visiting' }
CigPharoVisitor >> visitConstructor: aConstructor [

	(CigPharoGenerator on: self) 
		generateConstructor: aConstructor;
		generateCreator: aConstructor
]

{ #category : 'visiting' }
CigPharoVisitor >> visitEnum: anEnum [
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
CigPharoVisitor >> visitFunction: aFunction [

	"add function to associated namespace or to main library if no namespace provided"
	(CigPharoGenerator on: self) generateFunction: aFunction
]

{ #category : 'visiting' }
CigPharoVisitor >> visitMethod: aMethod [

	(aMethod isPublic not 
		or: [ aMethod isOperator ]) 
		ifTrue: [ ^ self ].

	(CigPharoGenerator on: self) generateMethod: aMethod
]

{ #category : 'visiting' }
CigPharoVisitor >> visitNamespace: aNamespace [
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
CigPharoVisitor >> visitStructure: aStructure [
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
CigPharoVisitor >> visitTypedef: aTypedef [
	| type |

	type := aTypedef resolveType.
	types 
		at: aTypedef cDeclaration
		put: (type phDeclarationWith: self prefix)
]

{ #category : 'visiting' }
CigPharoVisitor >> visitUnit: aUnit [

	self addFFILibrary: aUnit.
	self addFFITrait: aUnit.
	self addTypesClass: aUnit. 
	types := Dictionary new.
	structures := OrderedCollection new.
	self visitAll: aUnit elements.
	self addTypes: aUnit.
	
	structures do: #rebuildFieldAccessors 
]
