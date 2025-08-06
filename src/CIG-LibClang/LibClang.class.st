Class {
	#name : 'LibClang',
	#superclass : 'FFILibrary',
	#category : 'CIG-LibClang',
	#package : 'CIG-LibClang'
}

{ #category : 'options' }
LibClang class >> options [

	^ #( -optStrict )
]

{ #category : 'accessing - platform' }
LibClang >> macLibraryName [

	^ FFIMacLibraryFinder new
		  userPaths:
			  #( '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'
			     '/Library/Developer/CommandLineTools/usr/lib' );
		  findLibrary: 'libclang.dylib'
]

{ #category : 'accessing' }
LibClang >> runner [

	^ TFProcessLocalWorker new 
		defaultWorker: super runner;
		yourself
]

{ #category : 'accessing - platform' }
LibClang >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findAnyLibrary: #('libclang.so' 'libclang.so.1')
]
