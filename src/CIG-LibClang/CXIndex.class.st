Class {
	#name : 'CXIndex',
	#superclass : 'CXExternalObject',
	#classTraits : 'TLibClang classTrait',
	#category : 'CIG-LibClang',
	#package : 'CIG-LibClang'
}

{ #category : 'as yet unclassified' }
CXIndex class >> clang_createIndex: excludeDeclarationsFromPCH diagnostics: displayDiagnostics [

	self ffiCall: #(CXIndex clang_createIndex (
		int excludeDeclarationsFromPCH,
		int displayDiagnostics))
]

{ #category : 'as yet unclassified' }
CXIndex class >> createIndex: excludeDeclarationsFromPCH diagnostics: displayDiagnostics [

	^ (self clang_createIndex: excludeDeclarationsFromPCH diagnostics: displayDiagnostics) initialize
]

{ #category : 'accessing' }
CXIndex >> dispose [

	self ffiCall: #(void clang_disposeIndex(self))
]
