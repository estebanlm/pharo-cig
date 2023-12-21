Class {
	#name : 'IGCTemplateCollector',
	#superclass : 'IGVisitor',
	#instVars : [
		'type',
		'templates',
		'collected',
		'typeName'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'private' }
IGCTemplateCollector >> checkForTemplateSpecialization: aFunction [
		
	aFunction isTemplateSpecialization ifFalse: [ ^ self ].
	aFunction templateTypes ifNil: [ ^ self ].
	(aFunction underlyingTypeName beginsWith: (self typeName, '<')) ifFalse: [ ^ self ].

	collected addAll: aFunction templateTypes
]

{ #category : 'accessing' }
IGCTemplateCollector >> collected [

	^ collected
]

{ #category : 'accessing' }
IGCTemplateCollector >> typeName [

	^ typeName
]

{ #category : 'accessing' }
IGCTemplateCollector >> typeName: aString [

	typeName := aString
]

{ #category : 'visiting' }
IGCTemplateCollector >> visitConstructor: aConstructor [

	self visitFunction: aConstructor
]

{ #category : 'visiting' }
IGCTemplateCollector >> visitFunction: aFunction [

	self checkForTemplateSpecialization: aFunction.	
	aFunction parameters 
		do: [ :each | each accept: self ]
]

{ #category : 'visiting' }
IGCTemplateCollector >> visitMethod: aMethod [

	self visitFunction: aMethod
]

{ #category : 'visiting' }
IGCTemplateCollector >> visitParameter: aParameter [

	self checkForTemplateSpecialization: aParameter
]

{ #category : 'visiting' }
IGCTemplateCollector >> visitUnit: aUnit [

	collected := OrderedCollection new.
	super visitUnit: aUnit.
	collected removeDuplicates
]
