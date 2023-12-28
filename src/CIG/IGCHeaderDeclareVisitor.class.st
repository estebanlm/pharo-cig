"
A class to write the declarations to the header *before* anything else, to ensure they are declared.
"
Class {
	#name : 'IGCHeaderDeclareVisitor',
	#superclass : 'IGCBaseVisitor',
	#instVars : [
		'hStream'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'private' }
IGCHeaderDeclareVisitor >> addDefines: aDictionary [

	aDictionary keysAndValuesDo: [ :name :value | 
		self hStream << '#define ' << name.
		value ifNotNil: [ self hStream <<  ' ' << value ].
		self hStream cr ]
]

{ #category : 'accessing' }
IGCHeaderDeclareVisitor >> hStream [

	^ hStream
]

{ #category : 'accessing' }
IGCHeaderDeclareVisitor >> hStream: aStream [

	hStream := aStream

]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitClass: aClass [

	self hStream << aClass cTemplate generateHeader; cr.
	super visitClass: aClass
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitDefinesBeforeHeader: aUnit [

	self addDefines: aUnit definesBeforeHeader
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitEnum: anEnum [

	"skipping unnamed enums"
	anEnum isUnnamed ifTrue: [ ^ self ].

	self hStream << anEnum cTemplate generate; cr
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitNamespace: aNamespace [

	(self includesNamespace: aNamespace cppDeclaration) 
		ifTrue: [
			"skip the namespace since is already there, but try to process nested namespaces"
			self visitAll: (aNamespace elements select: [ :each | each isNamespace ]) ]
		ifFalse: [ 
			super visitNamespace: aNamespace ]
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitStructure: aStructure [

	aStructure isClass ifTrue: [ 
		self hStream << (IGCClassTemplate for: aStructure) generateHeader; cr.
		^ self ].

	"aStructure isOpaque ifTrue: [ ^ self ].	
	self hStream << aStructure cTemplate generate; cr"
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitTypedef: aTypedef [

	self hStream << aTypedef cTemplate generate; cr
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitUnit: aUnit [

	self addDefines: aUnit defines.
	^ super visitUnit: aUnit
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitUsingDeclaration: aDeclaration [

	aDeclaration isDeclaringTypedef 
		ifTrue: [ 
			self
				addTypedef: aDeclaration cppDeclaration
				as: aDeclaration cDeclaration ]
]
