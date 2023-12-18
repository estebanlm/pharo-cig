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

	self addTypedef: #void as: aClass fullName.
	super visitClass: aClass
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
IGCHeaderDeclareVisitor >> visitDefinesBeforeHeader: aUnit [

	self addDefines: aUnit definesBeforeHeader
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitEnum: anEnum [

	"skipping unnamed enums"
	anEnum isUnnamed ifTrue: [ ^ self ].

	"if it does not belongs to a namespace, it will be available at compile 
	 time in C, so we just generate it as a typedef"
	anEnum depth = 1 ifTrue: [ 
		^ self addTypedef: #int as: anEnum cDeclaration ].

	self hStream << 'enum ' << (self enumNameFor: anEnum) << ' {' << String cr.
	anEnum elements 
		do: [ :each | self hStream << '    ' << each name << ' = ' << each value asString ]
		separatedBy: [ self hStream << ',' << String cr ].
	self hStream << String cr << '};' << String cr.
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitStructure: aStructure [

	(aStructure isClass or: [ aStructure isOpaque ]) ifFalse: [ ^ self ].
	(IGCClassGenerator on: self) addClassTypedef: aStructure
]

{ #category : 'visiting' }
IGCHeaderDeclareVisitor >> visitTypedef: aTypedef [

	self
		addTypedef: aTypedef resolveType cDeclaration 
		as: aTypedef cDeclaration
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
