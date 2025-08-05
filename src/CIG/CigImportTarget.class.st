"
A target import: a header (e.g. ""array""), that may have a list of imports or may import all contents.
"
Class {
	#name : 'CigImportTarget',
	#superclass : 'Object',
	#instVars : [
		'name'
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
CigImportTarget >> headerName [

	^ self name asFileReference basename
]

{ #category : 'initialization' }
CigImportTarget >> initializeName: aName [
	
	self initialize.
	name := aName
]

{ #category : 'testing' }
CigImportTarget >> isUnit [

	^ false
]

{ #category : 'accessing' }
CigImportTarget >> name [

	^ name
]

{ #category : 'accessing' }
CigImportTarget >> newTranslateUnitOn: aTranslateUnit header: aHeader [

	self subclassResponsibility
]

{ #category : 'accessing' }
CigImportTarget >> processNode: aCursor ifAdd: addBlock ifInsert: insertBlock [
	
	^ addBlock value
]
