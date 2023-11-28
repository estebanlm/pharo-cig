Class {
	#name : 'CXFile',
	#superclass : 'CXExternalObject',
	#category : 'CIG-LibClang',
	#package : 'CIG',
	#tag : 'LibClang'
}

{ #category : 'private' }
CXFile >> clang_getFileName [

	^ self ffiCall: #(CXString clang_getFileName(self))
]

{ #category : 'accessing' }
CXFile >> fileName [
	| string |
	
	string := self clang_getFileName.
	^ [ string cString ]
		ensure: [ string dispose ]
]
