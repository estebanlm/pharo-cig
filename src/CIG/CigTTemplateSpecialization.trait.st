Trait {
	#name : 'CigTTemplateSpecialization',
	#instVars : [
		'specializationTypes'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'private' }
CigTTemplateSpecialization >> checkForTemplateSpecialization: aType [
	| templateArgs |

	"not interested on this."
	aType kind = CXType_Typedef ifTrue: [ ^ self ].
	"check for arguments"
	templateArgs := aType numTemplateArguments.
	templateArgs > 0 ifFalse: [ ^ self ].
	
	specializationTypes := OrderedCollection new.
	0 to: (templateArgs - 1) do: [ :index |
		| argType |
		argType := aType templateArgumentAsType: index.
		specializationTypes add: (CigFunctionParser parse: argType spelling) nameWithArity ]
]

{ #category : 'testing' }
CigTTemplateSpecialization >> isTemplateSpecialization [

	^ specializationTypes isEmptyOrNil not
]

{ #category : 'accessing' }
CigTTemplateSpecialization >> specializationTypes [

	^ specializationTypes
]
