Class {
	#name : 'IGVisitor',
	#superclass : 'Object',
	#instVars : [
		'file'
	],
	#category : 'LibClang-IG-',
	#package : 'LibClang-IG',
	#tag : ''
}

{ #category : 'accessing' }
IGVisitor >> file [

	^ file
]

{ #category : 'accessing' }
IGVisitor >> file: aHeaderFile [

	file := aHeaderFile
]

{ #category : 'visiting' }
IGVisitor >> visitAll: aCollection [

	aCollection do: [ :each | 
		each accept: self ]
]

{ #category : 'visiting' }
IGVisitor >> visitEnum: anEnum [
]

{ #category : 'visiting' }
IGVisitor >> visitFunction: aFunction [
]

{ #category : 'visiting' }
IGVisitor >> visitNamespace: aNamespace [

	aNamespace elements
		do: [ :each | each accept: self ]
]
