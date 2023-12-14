Class {
	#name : 'IGCBaseVisitor',
	#superclass : 'IGVisitor',
	#instVars : [
		'root'
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

{ #category : 'accessing' }
IGCBaseVisitor >> hStream [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
IGCBaseVisitor >> root [

	^ root
]
