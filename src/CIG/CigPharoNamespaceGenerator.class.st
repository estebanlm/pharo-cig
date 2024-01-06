Class {
	#name : 'CigPharoNamespaceGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'namespace',
		'generatedClass'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'instance creation' }
CigPharoNamespaceGenerator class >> newFile: aLibraryGenerator namespace: aNamespace [ 
	
	^ self new 
		file: aLibraryGenerator;
		unit: aNamespace root;
		namespace: aNamespace;
		yourself
]

{ #category : 'private' }
CigPharoNamespaceGenerator >> addCPPHeader [

	generatedClass class
		compile: self cppHeaderTemplate
		classified: 'accessing'
]

{ #category : 'private' }
CigPharoNamespaceGenerator >> addCPPName [

	generatedClass class
		compile: self cppNameTemplate
		classified: 'accessing'
]

{ #category : 'private' }
CigPharoNamespaceGenerator >> addCPPPrefix [

	generatedClass class
		compile: self cppPrefixTemplate
		classified: 'accessing'
]

{ #category : 'private' }
CigPharoNamespaceGenerator >> addNamespace [
	
	generatedClass := Object << self namespace phDeclaration asSymbol
		traits: self libraryTrait;
		tag: self namespace basename;
		package: self packageName;
		install
]

{ #category : 'private' }
CigPharoNamespaceGenerator >> addTypedef [

	generatedClass class
		compile: self typedefTemplate
		classified: 'accessing'
]

{ #category : 'private' }
CigPharoNamespaceGenerator >> cppHeaderTemplate [
		
	^ String streamContents: [ :stream |
		stream << 'cppHeader'; cr.
		stream cr; tab.
		stream << '^ ''' << self file libraryName << '.h''' ]
]

{ #category : 'private' }
CigPharoNamespaceGenerator >> cppNameTemplate [
		
	^ String streamContents: [ :stream |
		stream << 'cppName'; cr.
		stream cr; tab.
		stream << '^ ''' << self namespace cppDeclaration << '''' ]
]

{ #category : 'private' }
CigPharoNamespaceGenerator >> cppPrefixTemplate [
		
	^ String streamContents: [ :stream |
		stream << 'cppPrefix'; cr.
		stream cr; tab.
		stream << '^ ''' << self prefix asLowercase << '''' ]
]

{ #category : 'generating' }
CigPharoNamespaceGenerator >> generate [
	
	self addNamespace.
	self addCPPPrefix.
	self addCPPHeader.
	self addCPPName.
	self addTypedef
]

{ #category : 'accessing' }
CigPharoNamespaceGenerator >> namespace [

	^ namespace
]

{ #category : 'accessing' }
CigPharoNamespaceGenerator >> namespace: aNamespace [

	namespace := aNamespace
]

{ #category : 'private' }
CigPharoNamespaceGenerator >> typedefTemplate [
		
	^ String streamContents: [ :stream |
		stream << 'typedef'; cr.
		stream cr; tab.
		stream << '^ ' << self libraryTypedefName ]
]
