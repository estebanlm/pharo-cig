"
A class to write the declarations to the header *before* anything else, to ensure they are declared.
"
Class {
	#name : 'IGCHeaderDeclareVisitor',
	#superclass : 'IGCBaseVisitor',
	#instVars : [
		'hStream'
	],
	#category : 'CIG-Generate-C',
	#package : 'CIG',
	#tag : 'Generate-C'
}

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

	self addTypedef: #void as: aClass fullName.
	aClass elements 
		select: [ :each | each isTypedef ]
		thenDo: [ :each | each accept: self ]
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitClassTemplate: aClassTemplate [
	| cppName cName |

	"
	1. collect defined templates.
	2. generate a typedef for each.
	3. generate functions for each.
		- later, in pharo side, we will generate a class and a hierarchy
	"

	cName := aClassTemplate cDeclaration allButLast.
	cppName := aClassTemplate cppDeclaration.	
	self addTypedef: #void as: cName.
	(IGCTemplateCollector new
		typeName: cppName;
		visit: aClassTemplate root;
		collected)
		do: [ :each | 
			self addTypedef: #void as: (cName, each capitalized) ]
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitStructure: aStructure [

	aStructure isClass ifFalse: [ ^ self ].
	(IGCClassGenerator on: self) addClassTypedef: aStructure
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitTypedef: aTypedef [

	self
		addTypedef: aTypedef resolveType cDeclaration 
		as: aTypedef cDeclaration
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitUsingDeclaration: aDeclaration [

	aDeclaration isDeclaringTypedef 
		ifTrue: [ 
			self
				addTypedef: aDeclaration cppDeclaration
				as: aDeclaration cDeclaration ]
]
