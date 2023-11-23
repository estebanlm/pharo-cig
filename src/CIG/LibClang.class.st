Class {
	#name : 'LibClang',
	#superclass : 'FFILibrary',
	#category : 'CIG-LibClang',
	#package : 'CIG',
	#tag : 'LibClang'
}

{ #category : 'accessing - platform' }
LibClang >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libclang.so'
]
