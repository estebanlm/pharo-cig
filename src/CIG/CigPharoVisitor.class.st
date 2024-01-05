Class {
	#name : 'CigPharoVisitor',
	#superclass : 'CigVisitor',
	#instVars : [
		'types'
	],
	#category : 'CIG-Pharo',
	#package : 'CIG',
	#tag : 'Pharo'
}

{ #category : 'private' }
CigPharoVisitor >> addBaseClasses: aUnit [

	self addFFILibrary: aUnit.
	self addFFITrait: aUnit.
	self addFFITypesClass: aUnit
]

{ #category : 'private' }
CigPharoVisitor >> addFFILibrary: aUnit [ 
	
	(CigPharoLibraryGenerator newFile: self file unit: aUnit) generate
]

{ #category : 'private' }
CigPharoVisitor >> addFFITrait: aUnit [

	(CigPharoTraitGenerator newFile: self file unit: aUnit) generate
]

{ #category : 'private' }
CigPharoVisitor >> addFFITypesClass: aUnit [
	
	(CigPharoTypesPoolGenerator newFile: self file unit: aUnit) generate
]

{ #category : 'private' }
CigPharoVisitor >> ensureBaseObjectClass: aUnit [
	| generator |
	
	generator := CigPharoBaseObjectClassGenerator newFile: self file unit: aUnit.
	generator baseObjectClass ifNotNil: [ ^ self ].
	generator generate
]

{ #category : 'visiting' }
CigPharoVisitor >> visitClass: aClass [
	
	self ensureBaseObjectClass: aClass root.
	(CigPharoClassGenerator newFile: self file class: aClass) generate.
	super visitClass: aClass
]

{ #category : 'visiting' }
CigPharoVisitor >> visitConstructor: aConstructor [

	(CigPharoConstructorGenerator newFile: self file function: aConstructor) generate
]

{ #category : 'visiting' }
CigPharoVisitor >> visitEnum: anEnum [

]

{ #category : 'visiting' }
CigPharoVisitor >> visitFunction: aFunction [
	
	(CigPharoFunctionGenerator newFile: self file function: aFunction) generate
]

{ #category : 'visiting' }
CigPharoVisitor >> visitMethod: aMethod [

	(CigPharoMethodGenerator newFile: self file function: aMethod) generate
]

{ #category : 'visiting' }
CigPharoVisitor >> visitNamespace: aNamespace [

]

{ #category : 'visiting' }
CigPharoVisitor >> visitStructure: aStructure [

]

{ #category : 'visiting' }
CigPharoVisitor >> visitTypedef: aTypedef [

]

{ #category : 'visiting' }
CigPharoVisitor >> visitUnit: aUnit [

	self addBaseClasses: aUnit.
	super visitUnit: aUnit
]
