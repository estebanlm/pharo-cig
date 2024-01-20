Class {
	#name : 'CXDiagnostic',
	#superclass : 'CXExternalObject',
	#category : 'CIG-LibClang',
	#package : 'CIG-LibClang'
}

{ #category : 'private' }
CXDiagnostic >> clang_formatDiagnostic: options [

	^ self ffiCall: #(CXString clang_formatDiagnostic(CXDiagnostic self, uint options))
]

{ #category : 'private' }
CXDiagnostic >> clang_getDiagnosticSpelling [

	^ self ffiCall: #(CXString clang_getDiagnosticSpelling(CXDiagnostic self))
]

{ #category : 'accessing' }
CXDiagnostic >> defaultDiagnosticDisplayOptions [
		
	^ self ffiCall: #(uint clang_defaultDiagnosticDisplayOptions(void))
]

{ #category : 'accessing' }
CXDiagnostic >> spelling [
	| string |
	
	string := self clang_getDiagnosticSpelling.
	^ [ string cString ]
		ensure: [ string dispose ]
]

{ #category : 'accessing' }
CXDiagnostic >> string [
	| string |
	
	string := self clang_formatDiagnostic: self defaultDiagnosticDisplayOptions.
	^ [ string cString ]
		ensure: [ string dispose ]
]
