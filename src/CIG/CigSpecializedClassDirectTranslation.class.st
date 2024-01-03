Class {
	#name : 'CigSpecializedClassDirectTranslation',
	#superclass : 'CigClassDirectTranslation',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'testing' }
CigSpecializedClassDirectTranslation >> appliesTo: aType [
	| element |
	
	element := aType element.
	^ element notNil 
		and: [ element isClass 
		and: [ element isClassTemplate 
		and: [ aType isReference not
		and: [ aType isPointer not ] ] ] ]
]

{ #category : 'accessing' }
CigSpecializedClassDirectTranslation >> cDeclarationOf: aType [

	^ aType cDeclarationFromReferenceWithSpecialization: aType parent specializationTypes
]

{ #category : 'accessing' }
CigSpecializedClassDirectTranslation >> cppDeclarationOf: aType [

	^ aType cppDeclarationFromReferenceWithSpecialization: aType parent specializationTypes
]
