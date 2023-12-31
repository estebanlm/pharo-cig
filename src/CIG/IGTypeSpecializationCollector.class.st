Class {
	#name : 'IGTypeSpecializationCollector',
	#superclass : 'IGVisitor',
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
IGTypeSpecializationCollector >> checkForTemplateSpecialization: aFunction [
		
	aFunction isTemplateSpecialization ifFalse: [ ^ self ].
	aFunction specializationTypes ifNil: [ ^ self ].
	(aFunction underlyingTypeName beginsWith: (self typeName, '<')) ifFalse: [ ^ self ].

	collected addAll: aFunction specializationTypes
]

{ #category : 'accessing' }
IGTypeSpecializationCollector >> collected [

	^ collected
]

{ #category : 'accessing' }
IGTypeSpecializationCollector >> typeName [

	^ typeName
]

{ #category : 'accessing' }
IGTypeSpecializationCollector >> typeName: aString [

	typeName := aString
]

{ #category : 'visiting' }
IGTypeSpecializationCollector >> visitConstructor: aConstructor [

	self visitFunction: aConstructor
]

{ #category : 'visiting' }
IGTypeSpecializationCollector >> visitFunction: aFunction [

	self checkForTemplateSpecialization: aFunction.	
	aFunction parameters 
		do: [ :each | each accept: self ]
]

{ #category : 'visiting' }
IGTypeSpecializationCollector >> visitMethod: aMethod [

	self visitFunction: aMethod
]

{ #category : 'visiting' }
IGTypeSpecializationCollector >> visitParameter: aParameter [

	self checkForTemplateSpecialization: aParameter
]

{ #category : 'visiting' }
IGTypeSpecializationCollector >> visitUnit: aUnit [

	collected := OrderedCollection new.
	super visitUnit: aUnit.
	collected removeDuplicates
]
