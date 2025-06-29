Class {
	#name : 'CigImportedNamespaceElement',
	#superclass : 'Object',
	#instVars : [
		'path',
		'name',
		'cType',
		'reference'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigImportedNamespaceElement >> cDeclaration [

	^ self cType, (self isClass
		ifTrue: [ '*' ]
		ifFalse: [ '' ])
]

{ #category : 'accessing' }
CigImportedNamespaceElement >> cType [

	^ cType
]

{ #category : 'accessing' }
CigImportedNamespaceElement >> cType: aString [

	cType := aString
]

{ #category : 'accessing' }
CigImportedNamespaceElement >> cppDeclaration [

	^ self name
]

{ #category : 'testing' }
CigImportedNamespaceElement >> isClass [
	
	^ self reference class instanceSide inheritsFrom: FFIOpaqueObject
]

{ #category : 'testing' }
CigImportedNamespaceElement >> isEnum [
	
	^ self reference class instanceSide inheritsFrom: FFIEnumeration
]

{ #category : 'testing' }
CigImportedNamespaceElement >> isImportedNamespaceElement [

	^ true
]

{ #category : 'testing' }
CigImportedNamespaceElement >> isStructure [
	
	^ self reference class instanceSide inheritsFrom: FFIStructure
]

{ #category : 'testing' }
CigImportedNamespaceElement >> isTypedef [
	
	^ false
]

{ #category : 'testing' }
CigImportedNamespaceElement >> isUsingDeclaration [
	
	^ false
]

{ #category : 'accessing' }
CigImportedNamespaceElement >> name [

	^ String streamContents: [ :stream |
		self path 
			do: [ :each | stream nextPutAll: each asString ] 
			separatedBy: [ stream nextPutAll: '::' ] ]
]

{ #category : 'accessing' }
CigImportedNamespaceElement >> path [

	^ path
]

{ #category : 'accessing' }
CigImportedNamespaceElement >> path: aPath [

	path := aPath
]

{ #category : 'accessing' }
CigImportedNamespaceElement >> reference [

	^ reference
]

{ #category : 'accessing' }
CigImportedNamespaceElement >> reference: anObject [

	reference := anObject
]
