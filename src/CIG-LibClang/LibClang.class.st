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

{ #category : 'accessing' }
LibClang >> runner [

	^ TFProcessLocalWorker new 
		defaultWorker: super runner;
		yourself
]

{ #category : 'accessing - platform' }
LibClang >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findLibrary: 'libclang.so'
]
