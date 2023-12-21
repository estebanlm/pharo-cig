"
A class to write the declarations to the header *before* anything else, to ensure they are declared.
"
Class {
	#name : 'IGCHeaderDeclareVisitor2',
	#superclass : 'IGCBaseVisitor',
	#instVars : [
		'hStream'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'private' }
IGCHeaderDeclareVisitor2 >> addDefines: aDictionary [

	aDictionary keysAndValuesDo: [ :name :value | 
		self hStream << '#define ' << name.
		value ifNotNil: [ self hStream <<  ' ' << value ].
		self hStream cr ]
]

{ #category : 'accessing' }
IGCHeaderDeclareVisitor2 >> hStream [

	^ hStream
]

{ #category : 'accessing' }
IGCHeaderDeclareVisitor2 >> hStream: aStream [

	hStream := aStream

]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor2 >> visitClass: aClass [

	self hStream << aClass cTemplate generateHeader; cr.
	super visitClass: aClass
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor2 >> visitDefinesBeforeHeader: aUnit [

	self addDefines: aUnit definesBeforeHeader
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor2 >> visitEnum: anEnum [

	"skipping unnamed enums"
	anEnum isUnnamed ifTrue: [ ^ self ].

	self hStream << anEnum cTemplate generate; cr
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor2 >> visitStructure: aStructure [

	aStructure isClass ifTrue: [ 
		self hStream << (IGCClassTemplate for: aStructure) generateHeader; cr.
		^ self ].

	aStructure isOpaque ifTrue: [ ^ self ].
		
	self hStream << aStructure cTemplate generate; cr
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor2 >> visitTypedef: aTypedef [

	self hStream << aTypedef cTemplate generate; cr
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor2 >> visitUnit: aUnit [

	self addDefines: aUnit defines.
	^ super visitUnit: aUnit
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor2 >> visitUsingDeclaration: aDeclaration [

	aDeclaration isDeclaringTypedef 
		ifTrue: [ 
			self
				addTypedef: aDeclaration cppDeclaration
				as: aDeclaration cDeclaration ]
]
