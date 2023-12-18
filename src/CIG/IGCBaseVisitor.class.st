Class {
	#name : 'IGCBaseVisitor',
	#superclass : 'IGVisitor',
	#instVars : [
		'root',
		'unnamedEnum'
	],
	#category : 'CIG-Generate-C',
	#package : 'CIG',
	#tag : 'Generate-C'
}

{ #category : 'private - rendering' }
IGCBaseVisitor >> addTypedef: cppDecl as: cDecl [

	self hStream 
		<< ('typedef {1} {2};' format: { cppDecl. cDecl })
		<< String cr
]

{ #category : 'private' }
IGCBaseVisitor >> enumNameFor: anEnum [
	"yeah, enums can be unnamed :P"
	anEnum isUnnamed ifTrue: [
		unnamedEnum := unnamedEnum + 1.
		^ '{1}_unnamed_enum_{2}' format: { 
			anEnum root prefix asLowercase.			
			unnamedEnum } ].

	^ anEnum cDeclaration
]

{ #category : 'accessing' }
IGCBaseVisitor >> hStream [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
IGCBaseVisitor >> initialize [

	super initialize.
	unnamedEnum := 0
]

{ #category : 'accessing' }
IGCBaseVisitor >> root [

	^ root
]
