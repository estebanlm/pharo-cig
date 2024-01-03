Class {
	#name : 'CigTypeSpecializationCollector',
	#superclass : 'CigVisitor',
	#instVars : [
		'type',
		'templates',
		'collected',
		'typeName'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'private' }
CigTypeSpecializationCollector >> checkForTemplateSpecialization: aFunction [
		
	aFunction isTemplateSpecialization ifFalse: [ ^ self ].
	aFunction specializationTypes ifNil: [ ^ self ].
	(aFunction underlyingTypeName beginsWith: (self typeName, '<')) ifFalse: [ ^ self ].

	collected addAll: aFunction specializationTypes
]

{ #category : 'accessing' }
CigTypeSpecializationCollector >> collected [

	^ collected
]

{ #category : 'accessing' }
CigTypeSpecializationCollector >> typeName [

	^ typeName
]

{ #category : 'accessing' }
CigTypeSpecializationCollector >> typeName: aString [

	typeName := aString
]

{ #category : 'visiting' }
CigTypeSpecializationCollector >> visitConstructor: aConstructor [

	self visitFunction: aConstructor
]

{ #category : 'visiting' }
CigTypeSpecializationCollector >> visitFunction: aFunction [

	self checkForTemplateSpecialization: aFunction.	
	aFunction parameters 
		do: [ :each | each accept: self ]
]

{ #category : 'visiting' }
CigTypeSpecializationCollector >> visitMethod: aMethod [

	self visitFunction: aMethod
]

{ #category : 'visiting' }
CigTypeSpecializationCollector >> visitParameter: aParameter [

	self checkForTemplateSpecialization: aParameter
]

{ #category : 'visiting' }
CigTypeSpecializationCollector >> visitUnit: aUnit [

	collected := OrderedCollection new.
	super visitUnit: aUnit.
	collected removeDuplicates
]
