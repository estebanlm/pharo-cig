Trait {
	#name : 'IGTTemplateSpecialization',
	#instVars : [
		'templateTypes'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'private' }
IGTTemplateSpecialization >> checkForTemplateSpecialization: aType [
	| templateArgs |

	"not interested on this."
	aType kind = CXType_Typedef ifTrue: [ ^ self ].
	"check for arguments"
	templateArgs := aType numTemplateArguments.
	templateArgs > 0 ifFalse: [ ^ self ].
	
	templateTypes := OrderedCollection new.
	0 to: (templateArgs - 1) do: [ :index |
		| argType |
		argType := aType templateArgumentAsType: index.
		templateTypes add: (IGFunctionParser parse: argType spelling) nameWithArity ]
]

{ #category : 'testing' }
IGTTemplateSpecialization >> isTemplateSpecialization [

	^ templateTypes isEmptyOrNil not
]

{ #category : 'accessing' }
IGTTemplateSpecialization >> templateTypes [

	^ templateTypes
]
