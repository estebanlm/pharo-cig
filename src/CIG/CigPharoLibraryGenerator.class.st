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

{ #category : 'private' }
CigPharoLibraryGenerator >> addClass [
	| ffiLibraryName |

	ffiLibraryName := self libraryName.
	generatedClass := FFILibrary << ffiLibraryName asSymbol
		tag: 'Library';
		package: self packageName;
		install
]

{ #category : 'private' }
CigPharoLibraryGenerator >> addLinuxPlatformAccessor [
	
	generatedClass
		compile: self linuxPlatformTemplate
		classified: 'accessing - platform'
]

{ #category : 'private' }
CigPharoLibraryGenerator >> addMacPlatformAccessor [
	
	generatedClass
		compile: self macPlatformTemplate
		classified: 'accessing - platform'
]

{ #category : 'private' }
CigPharoLibraryGenerator >> addWinPlatformAccessor [
	
	generatedClass
		compile: self winPlatformTemplate
		classified: 'accessing - platform'
]

{ #category : 'generating' }
CigPharoLibraryGenerator >> generate [

	self addClass.
	self addLinuxPlatformAccessor.
	self addWinPlatformAccessor.
	self addMacPlatformAccessor
]

{ #category : 'private' }
CigPharoLibraryGenerator >> linuxPlatformTemplate [

	^ String streamContents: [ :stream | 
		stream << 'unix64LibraryName'; cr.
		stream cr; tab.
		stream << '^ FFIUnix64LibraryFinder findLibrary: ''' << self file libraryName << '.so''' ]
]

{ #category : 'private' }
CigPharoLibraryGenerator >> macPlatformTemplate [
		
	^ String streamContents: [ :stream | 
		stream << 'macLibraryName'; cr.
		stream cr; tab.
		stream << '^ FFIMacLibraryFinder findLibrary: ''' << self file libraryName << '.dylib''' ]
]

{ #category : 'private' }
CigPharoLibraryGenerator >> winPlatformTemplate [
		
	^ String streamContents: [ :stream | 
		stream << 'win32LibraryName'; cr.
		stream cr; tab.
		stream << '^ FFIWindowsLibraryFinder findLibrary: ''' << self file libraryName << '.dll''' ]
]
