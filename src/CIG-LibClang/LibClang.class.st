Class {
	#name : 'LibClang',
	#superclass : 'FFILibrary',
	#category : 'CIG-LibClang',
	#package : 'CIG-LibClang'
}

{ #category : 'accessing - platform' }
LibClang >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libclang.so'
]
