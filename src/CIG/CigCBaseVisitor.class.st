"
A base visitor to produce C files.
"
Class {
	#name : 'CigCBaseVisitor',
	#superclass : 'CigVisitor',
	#instVars : [
		'root',
		'unnamedEnum'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'private - rendering' }
CigCBaseVisitor >> addTypedef: cppDecl as: cDecl [

	self hStream 
		<< ('typedef {1} {2};' format: { cppDecl. cDecl })
		<< String cr
]

{ #category : 'private' }
CigCBaseVisitor >> enumNameFor: anEnum [
	"yeah, enums can be unnamed :P"
	anEnum isUnnamed ifTrue: [
		unnamedEnum := unnamedEnum + 1.
		^ '{1}_unnamed_enum_{2}' format: { 
			anEnum root prefix asLowercase.			
			unnamedEnum } ].

	^ anEnum cDeclaration
]

{ #category : 'accessing' }
CigCBaseVisitor >> hStream [

	^ self subclassResponsibility
]

{ #category : 'initialization' }
CigCBaseVisitor >> initialize [

	super initialize.
	unnamedEnum := 0
]

{ #category : 'accessing' }
CigCBaseVisitor >> root [

	^ root
]
