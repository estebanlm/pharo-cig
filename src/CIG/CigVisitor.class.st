Class {
	#name : 'CigVisitor',
	#superclass : 'Object',
	#instVars : [
		'file'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigVisitor >> file [

	^ file
]

{ #category : 'accessing' }
CigVisitor >> file: aHeaderFile [

	file := aHeaderFile
]

{ #category : 'testing' }
CigVisitor >> includesNamespace: aNamespace [

	^ self file includesNamespace: aNamespace

]

{ #category : 'visiting' }
CigVisitor >> visit: anObject [

	anObject accept: self
]

{ #category : 'visiting' }
CigVisitor >> visitAll: aCollection [

	aCollection do: [ :each | 
		each accept: self ]
]

{ #category : 'visiting' }
CigVisitor >> visitClass: aClass [

	self visitAll: aClass elements
]

{ #category : 'visiting' }
CigVisitor >> visitClassTemplate: aClassTemplate [

	self visitClass: aClassTemplate
]

{ #category : 'visiting' }
CigVisitor >> visitConstructor: aConstructor [
]

{ #category : 'visiting' }
CigVisitor >> visitDestructor: aDestructor [
]

{ #category : 'visiting' }
CigVisitor >> visitEnum: anEnum [
]

{ #category : 'visiting' }
CigVisitor >> visitFunction: aFunction [
]

{ #category : 'visiting' }
CigVisitor >> visitMethod: aMethod [
]

{ #category : 'visiting' }
CigVisitor >> visitNamespace: aNamespace [

	self visitAll: aNamespace elements
]

{ #category : 'visiting' }
CigVisitor >> visitParameter: aParameter [
	
]

{ #category : 'visiting' }
CigVisitor >> visitStructure: aStructure [
]

{ #category : 'visiting' }
CigVisitor >> visitTypedef: aTypedef [
]

{ #category : 'visiting' }
CigVisitor >> visitUnit: aUnit [

	self visitAll: aUnit elements
]

{ #category : 'visiting' }
CigVisitor >> visitUnknown: anUnknown [
]

{ #category : 'visiting' }
CigVisitor >> visitUsingDeclaration: anElement [

]

{ #category : 'visiting' }
CigVisitor >> visitVariable: aVariable [
]
