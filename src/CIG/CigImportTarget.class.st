Class {
	#name : 'CigImportTarget',
	#superclass : 'Object',
	#instVars : [
		'name',
		'imports'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'instance creation' }
CigImportTarget class >> newName: aString [

	^ self basicNew
		initializeName: aString;
		yourself
]

{ #category : 'private' }
CigImportTarget >> belongsToImportedElement: aCursor [
	| path |
	
	path := aCursor lexicalPath.
	path ifEmpty: [ ^ false ].
	^ self isPathImported: path allButLast
]

{ #category : 'accessing' }
CigImportTarget >> import: aCollection [

	imports ifNil: [ imports := Set new ].
	imports addAll: aCollection
]

{ #category : 'accessing' }
CigImportTarget >> importAll [

	imports := nil
]

{ #category : 'initialization' }
CigImportTarget >> initializeName: aName [
	
	self initialize.
	name := aName
]

{ #category : 'private' }
CigImportTarget >> isPathImported: path [	

	path ifEmpty: [ ^ false ].
	(imports includes: ('::' join: path)) ifTrue: [ ^ true ].
	^ self isPathImported: path allButLast
]

{ #category : 'accessing' }
CigImportTarget >> name [

	^ name
]

{ #category : 'adding' }
CigImportTarget >> processNode: aCursor ifAdd: addBlock ifInsert: insertBlock [
	| cppName |

	(imports isNil or: [ self belongsToImportedElement: aCursor ])
		ifTrue: [ ^ addBlock value ].

	cppName := '::' join: aCursor lexicalPath.
	(imports includes: cppName) 
		ifTrue: [ insertBlock value ]
]
