Class {
	#name : 'IGVisitor',
	#superclass : 'Object',
	#instVars : [
		'file'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
IGVisitor >> file [

	^ file
]

{ #category : 'accessing' }
IGVisitor >> file: aHeaderFile [

	file := aHeaderFile
]

{ #category : 'testing' }
IGVisitor >> includesNamespace: aNamespace [

	^ self file includesNamespace: aNamespace

]

{ #category : 'visiting' }
IGVisitor >> visit: anObject [

	anObject accept: self
]

{ #category : 'visiting' }
IGVisitor >> visitAll: aCollection [

	aCollection do: [ :each | 
		each accept: self ]
]

{ #category : 'visiting' }
IGVisitor >> visitClass: aClass [

	self visitAll: aClass elements
]

{ #category : 'visiting' }
IGVisitor >> visitConstructor: aConstructor [
]

{ #category : 'visiting' }
IGVisitor >> visitDestructor: aDestructor [
]

{ #category : 'visiting' }
IGVisitor >> visitEnum: anEnum [
]

{ #category : 'visiting' }
IGVisitor >> visitFunction: aFunction [
]

{ #category : 'visiting' }
IGVisitor >> visitMethod: aMethod [
]

{ #category : 'visiting' }
IGVisitor >> visitNamespace: aNamespace [

	self visitAll: aNamespace elements
]

{ #category : 'visiting' }
IGVisitor >> visitStructure: aStructure [
]

{ #category : 'visiting' }
IGVisitor >> visitTypedef: aTypedef [
]

{ #category : 'visiting' }
IGVisitor >> visitUnit: aUnit [
]

{ #category : 'visiting' }
IGVisitor >> visitUnknown: anUnknown [
]

{ #category : 'visiting' }
IGVisitor >> visitVariable: aVariable [
]
