Class {
	#name : 'IGSpecializedClassDirectTranslation',
	#superclass : 'IGClassDirectTranslation',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'testing' }
IGSpecializedClassDirectTranslation >> appliesTo: aType [
	| element |
	
	element := aType element.
	^ element notNil 
		and: [ element isClass 
		and: [ element isClassTemplate 
		and: [ aType isReference not
		and: [ aType isPointer not ] ] ] ]
]

{ #category : 'accessing' }
IGSpecializedClassDirectTranslation >> cDeclarationOf: aType [

	^ aType cDeclarationFromReferenceWithSpecialization: aType parent specializationTypes
]

{ #category : 'accessing' }
IGSpecializedClassDirectTranslation >> cppDeclarationOf: aType [

	^ aType cppDeclarationFromReferenceWithSpecialization: aType parent specializationTypes
]
