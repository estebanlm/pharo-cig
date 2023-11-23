Class {
	#name : 'CXString',
	#superclass : 'CXExternalObject',
	#category : 'LibClang',
	#package : 'LibClang'
}

{ #category : 'accessing' }
CXString >> cString [

	^ self ffiCall: #(char *clang_getCString(self))
]

{ #category : 'accessing' }
CXString >> dispose [

	self ffiCall: #(void clang_disposeString(self))
]
