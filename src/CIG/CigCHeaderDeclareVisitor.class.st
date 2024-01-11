"
A class to write the declarations to the header *before* anything else, to ensure they are declared.
"
Class {
	#name : 'CigCHeaderDeclareVisitor',
	#superclass : 'CigCBaseVisitor',
	#instVars : [
		'hStream'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'private' }
CigCHeaderDeclareVisitor >> addDefines: aDictionary [

	aDictionary keysAndValuesDo: [ :name :value | 
		self hStream << '#define ' << name.
		value ifNotNil: [ self hStream <<  ' ' << value ].
		self hStream cr ]
]

{ #category : 'accessing' }
CigCHeaderDeclareVisitor >> hStream [

	^ hStream
]

{ #category : 'accessing' }
CigCHeaderDeclareVisitor >> hStream: aStream [

	hStream := aStream

]

{ #category : 'visiting' }
CigCHeaderDeclareVisitor >> visitClass: aClass [

	self hStream << aClass cTemplate generateHeader; cr.
	super visitClass: aClass
]

{ #category : 'visiting' }
CigCHeaderDeclareVisitor >> visitDefinesBeforeHeader: aUnit [

	self addDefines: aUnit definesBeforeHeader
]

{ #category : 'visiting' }
CigCHeaderDeclareVisitor >> visitEnum: anEnum [

	"skip if not public (it can be nested in a class)"
	anEnum isPublic ifFalse: [ ^ self ].

	"skipping unnamed enums"
	anEnum isUnnamed ifTrue: [ ^ self ].

	self hStream << anEnum cTemplate generate; cr
]

{ #category : 'visiting' }
CigCHeaderDeclareVisitor >> visitNamespace: aNamespace [

	(self includesNamespace: aNamespace cppDeclaration) 
		ifTrue: [
			"skip the namespace since is already there, but try to process nested namespaces"
			self visitAll: (aNamespace elements select: [ :each | each isNamespace ]) ]
		ifFalse: [ 
			super visitNamespace: aNamespace ]
]

{ #category : 'visiting' }
CigCHeaderDeclareVisitor >> visitStructure: aStructure [

	aStructure isClass ifTrue: [ 
		self hStream << (CigCClassTemplate for: aStructure) generateHeader; cr.
		^ self ].

	"aStructure isOpaque ifTrue: [ ^ self ].	
	self hStream << aStructure cTemplate generate; cr"
]

{ #category : 'visiting' }
CigCHeaderDeclareVisitor >> visitTypedef: aTypedef [

	aTypedef isPublic ifFalse: [ ^ self ].
	self hStream << aTypedef cTemplate generate; cr
]

{ #category : 'visiting' }
CigCHeaderDeclareVisitor >> visitUnit: aUnit [

	self addDefines: aUnit defines.
	^ super visitUnit: aUnit
]

{ #category : 'visiting' }
CigCHeaderDeclareVisitor >> visitUsingDeclaration: aDeclaration [

	aDeclaration isDeclaringTypedef 
		ifTrue: [ 
			self
				addTypedef: aDeclaration cppDeclaration
				as: aDeclaration cDeclaration ]
]
