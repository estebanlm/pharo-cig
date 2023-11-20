Class {
	#name : 'LibClang',
	#superclass : 'FFILibrary',
	#category : 'LibClang',
	#package : 'LibClang'
}

{ #category : 'accessing - platform' }
LibClang >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libclang.so'
]
