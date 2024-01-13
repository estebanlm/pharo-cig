Trait {
	#name : 'CigTTemplateSpecialization',
	#instVars : [
		'specializationTypes'
	],
	#classTraits : '{} + TraitedClass',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'private' }
CigTTemplateSpecialization >> checkForTemplateSpecialization: aType name: aTypeName [
	| templateArgs |
	
	(aTypeName includes: $<) ifFalse: [ ^ self ].

	"check for arguments"
	templateArgs := aType numTemplateArguments.
	templateArgs > 0 ifFalse: [ ^ self ].
	
	specializationTypes := OrderedCollection new.
	0 to: (templateArgs - 1) do: [ :index |
		| argType |
		argType := aType templateArgumentAsType: index.
		specializationTypes add: (argType spelling 
			ifNotEmpty: [ :aName | | n |
				n := (CigFunctionParser parse: aName) nameWithArity.
				(aName -> n) crTrace.
				n ]
			ifEmpty: [ self extractSpecializationValueIndex: index + 1 of: aTypeName ]) ]
]

{ #category : 'private' }
CigTTemplateSpecialization >> extractSpecializationTypesOf: aName [
	
	^ (CigFunctionParser parse: aName) templates
]

{ #category : 'private' }
CigTTemplateSpecialization >> extractSpecializationValueIndex: index of: aName [

	^ (self extractSpecializationTypesOf: aName) at: index
]

{ #category : 'testing' }
CigTTemplateSpecialization >> isTemplateSpecialization [

	^ specializationTypes isEmptyOrNil not
]

{ #category : 'accessing' }
CigTTemplateSpecialization >> specializationTypes [

	^ specializationTypes
]
