Class {
	#name : 'CXString',
	#superclass : 'CXExternalObject',
	#category : 'CIG-LibClang',
	#package : 'CIG',
	#tag : 'LibClang'
}

{ #category : 'accessing' }
CXString >> cString [

	^ self ffiCall: #(char *clang_getCString(self))
]

{ #category : 'accessing' }
CXString >> dispose [

	self ffiCall: #(void clang_disposeString(self))
]
