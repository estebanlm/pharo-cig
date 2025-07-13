Class {
	#name : 'CigImportTargetUnit',
	#superclass : 'CigImportTarget',
	#instVars : [
		'unit'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigImportTargetUnit >> import: aString [

	self unit: aString
]

{ #category : 'testing' }
CigImportTargetUnit >> isUnit [

	^ true
]

{ #category : 'accessing' }
CigImportTargetUnit >> newTranslateUnitOn: aTranslateUnit header: aHeader [

	^ aTranslateUnit 
		newTranslateUnitFromUnit: self 
		header: aHeader
]

{ #category : 'accessing' }
CigImportTargetUnit >> unit [

	^ unit
]

{ #category : 'accessing' }
CigImportTargetUnit >> unit: aString [

	unit := aString
]
