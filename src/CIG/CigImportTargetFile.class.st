Class {
	#name : 'CigImportTargetFile',
	#superclass : 'CigImportTarget',
	#instVars : [
		'imports'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'private' }
CigImportTargetFile >> belongsToImportedElement: aCursor [
	| path |
	
	path := aCursor lexicalPath.
	path ifEmpty: [ ^ false ].
	^ self isPathImported: path allButLast
]

{ #category : 'accessing' }
CigImportTargetFile >> import: aCollection [

	imports ifNil: [ imports := Set new ].
	imports addAll: aCollection
]

{ #category : 'accessing' }
CigImportTargetFile >> importAll [

	imports := nil
]

{ #category : 'testing' }
CigImportTargetFile >> isPathImported: path [	

	path ifEmpty: [ ^ false ].
	(imports includes: ('::' join: path)) ifTrue: [ ^ true ].
	^ self isPathImported: path allButLast
]

{ #category : 'accessing' }
CigImportTargetFile >> newTranslateUnitOn: aTranslateUnit header: aHeader [

	^ aTranslateUnit 
		newTranslateUnitFromFile: self 
		header: aHeader
]

{ #category : 'accessing' }
CigImportTargetFile >> processNode: aCursor ifAdd: addBlock ifInsert: insertBlock [
	| cppName |

	(imports isNil or: [ self belongsToImportedElement: aCursor ])
		ifTrue: [ ^ addBlock value ].

	cppName := '::' join: aCursor lexicalPath.
	(imports includes: cppName) 
		ifTrue: [ insertBlock value ]
]
