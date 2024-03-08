Class {
	#name : 'CigPharoLibraryGenerator',
	#superclass : 'CigPharoGenerator',
	#instVars : [
		'generatedClass'
	],
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'private - adding' }
CigPharoLibraryGenerator >> addClass [
	| ffiLibraryName |

	ffiLibraryName := self libraryName.
	generatedClass := FFILibrary << ffiLibraryName asSymbol
		sharedPools: self sharedPoolNames;
		tag: 'Library';
		package: self packageName;
		install
]

{ #category : 'private - adding' }
CigPharoLibraryGenerator >> addLinuxPlatformAccessor [
	
	generatedClass
		compile: self linuxPlatformTemplate
		classified: 'accessing - platform'
]

{ #category : 'private - adding' }
CigPharoLibraryGenerator >> addMacPlatformAccessor [
	
	generatedClass
		compile: self macPlatformTemplate
		classified: 'accessing - platform'
]

{ #category : 'private - adding' }
CigPharoLibraryGenerator >> addRunner [
	

	generatedClass
		compile: self runnerTemplate
		classified: 'accessing'
]

{ #category : 'private - adding' }
CigPharoLibraryGenerator >> addWinPlatformAccessor [
	
	generatedClass
		compile: self winPlatformTemplate
		classified: 'accessing - platform'
]

{ #category : 'generating' }
CigPharoLibraryGenerator >> generate [

	self addClass.
	self addRunner.
	self addLinuxPlatformAccessor.
	self addWinPlatformAccessor.
	self addMacPlatformAccessor.
]

{ #category : 'private - templates' }
CigPharoLibraryGenerator >> linuxPlatformTemplate [

	^ String streamContents: [ :stream | 
		stream << 'unix64LibraryName'; cr.
		stream cr; tab.
		stream << '^ FFIUnix64LibraryFinder findLibrary: ''' << self file libraryName << '.so''' ]
]

{ #category : 'private - templates' }
CigPharoLibraryGenerator >> macPlatformTemplate [
		
	^ String streamContents: [ :stream | 
		stream << 'macLibraryName'; cr.
		stream cr; tab.
		stream << '^ FFIMacLibraryFinder findLibrary: ''' << self file libraryName << '.dylib''' ]
]

{ #category : 'private - templates' }
CigPharoLibraryGenerator >> runnerTemplate [

	^ ('runner
	
	^ TFProcessLocalWorker new 
		defaultWorker: {1};
		yourself')
		format: { self file ffiRunner phTemplate }
]

{ #category : 'private - templates' }
CigPharoLibraryGenerator >> winPlatformTemplate [
		
	^ String streamContents: [ :stream | 
		stream << 'win32LibraryName'; cr.
		stream cr; tab.
		stream << '^ FFIWindowsLibraryFinder findLibrary: ''' << self file libraryName << '.dll''' ]
]
