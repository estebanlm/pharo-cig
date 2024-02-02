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

{ #category : 'accessing' }
CigImportTarget >> name [

	^ name
]

{ #category : 'adding' }
CigImportTarget >> processNode: aCursor ifAdd: addBlock ifInsert: insertBlock [
	| cppName |

	imports ifNil: [ ^ addBlock value ].
	
	cppName := '::' join: aCursor path.
	(cppName = 'std::array') ifTrue: [
		imports crTrace
		].
	(imports includes: cppName)
		ifTrue: [ insertBlock value ]
]
