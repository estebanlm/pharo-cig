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

{ #category : 'private - adding' }
IGPharoVisitor >> addClass: aName extends: aClass tag: aTag [
	| builder |
	
	builder := aClass << aName asSymbol.
	
	(aClass package name = self packageName) ifFalse: [  
		builder
			traits: self libraryTrait;
			sharedPools: { self typesName asSymbol } ].
	
	^ builder
		tag: aTag;
		package: self packageName;
		install
]

{ #category : 'private - adding' }
IGPharoVisitor >> addFFILibrary: aUnit [
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
IGPharoVisitor >> addFFITrait: aUnit [
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

{ #category : 'private - adding' }
IGPharoVisitor >> addTypesClass: aUnit [
	| typesName |

	typesName := self typesName.
	SharedPool << typesName asSymbol
		tag: 'Library';
		package: self packageName;
		install
]

{ #category : 'private' }
IGPharoVisitor >> classFor: aSymbol [
	
	^ self class environment at: aSymbol asSymbol
]

{ #category : 'private - accessing' }
IGPharoVisitor >> libraryName [

	^ 'Lib', self file bindingsName capitalized
]

{ #category : 'private - accessing' }
IGPharoVisitor >> libraryTrait [
		
	^ self class environment at: (self libraryTraitName asSymbol)
]

{ #category : 'private - accessing' }
IGPharoVisitor >> libraryTraitName [

	^ 'LibT', self file bindingsName capitalized
]

{ #category : 'private' }
IGPharoVisitor >> namespaceFor: aNode [
	| current |
	
	current := aNode.
	[ current notNil ] 
	whileTrue: [ 
		current isNamespace ifTrue: [ ^ current ].
		current := current parent ].
	^ nil
]

{ #category : 'private' }
IGPharoVisitor >> namespaceForClass: aClass [

	^ (self namespaceFor: aClass) 
		ifNotNil: [ :aNamespace | aNamespace basename capitalized ]
		ifNil: [ 'Library' ]
]

{ #category : 'private' }
IGPharoVisitor >> namespaceForEnum: anEnum [

	^ (self namespaceFor: anEnum) 
		ifNotNil: [ :aNamespace | aNamespace basename capitalized ]
		ifNil: [ 'Library' ]
]

{ #category : 'private' }
IGPharoVisitor >> namespaceForStructure: aStructure [

	^ self namespaceForEnum: aStructure
]

{ #category : 'private - accessing' }
IGPharoVisitor >> packageName [

	^ 'Lib', self file bindingsName capitalized
]

{ #category : 'private - accessing' }
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

{ #category : 'private - adding' }
IGPharoVisitor >> typesClass [

	^ self class environment at: self typesName asSymbol
]

{ #category : 'private - adding' }
IGPharoVisitor >> typesName [

	^ self prefix, self file bindingsName capitalized, 'Typedef'
]

{ #category : 'visiting' }
IGPharoVisitor >> visitClass: aClass [

	self registerType: aClass.
	self 
		addClass: (aClass phDeclarationWith: self prefix) 
		extends: (self superclassFor: aClass)
		tag: (self namespaceForClass: aClass).
	self visitAll: aClass elements.
	aClass isAbstract ifFalse: [ 
		(IGPharoGenerator on: self) generateDispose: aClass ]
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

	"avoid to create a namespace if there are no functions to be installed"
	aNamespace hasFunctions ifTrue: [
		self 
			addClass: (aNamespace phDeclarationWith: self prefix) 
			extends: Object
			tag: aNamespace basename capitalized ].
	
	self visitAll: aNamespace elements
]

{ #category : 'visiting' }
IGPharoVisitor >> visitStructure: aStructure [
	| struct template |

	self registerType: aStructure.
	
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
		
	struct rebuildFieldAccessors 
]

{ #category : 'visiting' }
IGPharoVisitor >> visitTypedef: aTypedef [

	types 
		at: aTypedef cDeclaration
		put: (aTypedef resolveType phDeclarationWith: self prefix)
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
