Class {
	#name : 'FFIFunctionReference',
	#superclass : 'FFICallback',
	#category : 'CIG-FFI-Support',
	#package : 'CIG',
	#tag : 'FFI-Support'
}

{ #category : 'converting' }
FFIFunctionReference class >> asExternalTypeOn: generator [

	^ FFIFunctionReferenceType objectClass: self
]
