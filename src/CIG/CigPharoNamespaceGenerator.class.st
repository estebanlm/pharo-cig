Class {
	#name : 'CigPharoNamespaceGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

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
	| name |
	
	name := self nameForClass.
	logger trace: name.
	
	generatedClass := Object << name
		traits: self libraryTrait;
		tag: self element basename capitalized;
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
		stream << '^ ''' << self element cppDeclaration << '''' ]
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

{ #category : 'private' }
CigPharoNamespaceGenerator >> nameForClass [
	
	^ self element phDeclaration asSymbol
]

{ #category : 'private' }
CigPharoNamespaceGenerator >> typedefTemplate [
		
	^ String streamContents: [ :stream |
		stream << 'typedef'; cr.
		stream cr; tab.
		stream << '^ ' << self libraryTypedefName ]
]
