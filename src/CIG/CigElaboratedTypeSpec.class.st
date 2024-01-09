Class {
	#name : 'CigElaboratedTypeSpec',
	#superclass : 'Object',
	#instVars : [
		'underlyingTypeName',
		'underlyingTypeKind',
		'recordKind',
		'definesFunction',
		'definesArray',
		'specializationTypes'
	],
	#pools : [
		'CXTypeKind'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'instance creation' }
CigElaboratedTypeSpec class >> fromType: aCXType [

	^ self new fromType: aCXType
]

{ #category : 'private' }
CigElaboratedTypeSpec >> checkForTemplateSpecialization: aType [
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
		specializationTypes add: (argType spelling 
			ifNotEmpty: [ :aName | (CigFunctionParser parse: aName) nameWithArity ]
			ifEmpty: [ self extractSpecializationValueIndex: index + 1 ]) ]
]

{ #category : 'private' }
CigElaboratedTypeSpec >> extractSpecializationValueIndex: index [
	| elementName |

	elementName := (((underlyingTypeName copyAfter: $<) copyUpToLast: $>) substrings: ', ') at: index.
	^ elementName
]

{ #category : 'initialization' }
CigElaboratedTypeSpec >> fromType: type [
	| underlyingType |
		
	underlyingType :=  type namedType.
	underlyingTypeName := underlyingType spelling.
	underlyingTypeKind := underlyingType kind.
	(underlyingTypeName indexOf: $<) > 0 
		ifTrue: [ self checkForTemplateSpecialization: underlyingType ].
	underlyingTypeKind = CXType_Record 
		ifTrue: [ recordKind := underlyingType typeDeclaration kind ].
		
	definesFunction := underlyingTypeKind = CXType_Pointer 
		and: [ type pointeeType resultType ~= CXType_Invalid ].
	definesArray := underlyingTypeKind = CXType_ConstantArray 
			or: [ underlyingTypeKind = CXType_IncompleteArray
			or: [ underlyingTypeKind = CXType_VariableArray ] ]	
]

{ #category : 'testing' }
CigElaboratedTypeSpec >> isTemplateSpecialization [

	^ specializationTypes isEmptyOrNil not
]

{ #category : 'accessing' }
CigElaboratedTypeSpec >> recordKind [

	^ recordKind
]

{ #category : 'accessing' }
CigElaboratedTypeSpec >> specializationTypes [

	^ specializationTypes
]

{ #category : 'accessing' }
CigElaboratedTypeSpec >> underlyingTypeKind [

	^ underlyingTypeKind
]

{ #category : 'accessing' }
CigElaboratedTypeSpec >> underlyingTypeName [

	^ underlyingTypeName
]
