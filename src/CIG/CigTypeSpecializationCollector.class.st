"
A collector of specialisations declared on a translation unit.
Basically, it traverses all elements looking for specialisations (template specialisations, e.g. aType<Int>) to be used to declare a hierarcht with them (this is added to the specialisations declared manually on the header spec).

"
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
CigTypeSpecializationCollector >> checkForDefinedTemplateSpecialization: aClassTemplate [
	| cppDecl |
		
	cppDecl := aClassTemplate cppDeclaration.
	aClassTemplate root classSpecializations do: [ :each | | parsed |
		parsed := CigFunctionParser parse: each.
		parsed name = cppDecl 
			ifTrue: [ collected add: parsed templates ] ]
]

{ #category : 'private' }
CigTypeSpecializationCollector >> checkForTemplateSpecialization: anElement [
		
	anElement isTemplateSpecialization ifFalse: [ ^ self ].
	anElement specializationTypes ifNil: [ ^ self ].
	(anElement underlyingTypeName beginsWith: (self typeName, '<')) ifFalse: [ ^ self ].

	collected addAll: anElement specializationTypes
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
CigTypeSpecializationCollector >> visitClassTemplate: aClassTemplate [

	self checkForDefinedTemplateSpecialization: aClassTemplate.
	super visitClassTemplate: aClassTemplate
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
