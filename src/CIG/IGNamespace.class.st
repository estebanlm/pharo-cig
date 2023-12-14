Class {
	#name : 'IGNamespace',
	#superclass : 'IGElement',
	#instVars : [
		'originPath'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'instance creation' }
IGNamespace class >> fromCursor: aCursor [

	^ self new fromCursor: aCursor
]

{ #category : 'accessing' }
IGNamespace class >> kind [

	^ CXCursor_Namespace
]

{ #category : 'visiting' }
IGNamespace >> accept: aVisitor [

	aVisitor visitNamespace: self
]

{ #category : 'testing' }
IGNamespace >> acceptNestedClasses [

	^ true
]

{ #category : 'initialization' }
IGNamespace >> fromCursor: aCursor [

	super fromCursor: aCursor.
	originPath := aCursor withAllParents allButFirst collect: [ :each | each displayName ]
]

{ #category : 'accessing' }
IGNamespace >> functions [

	^ self elements select: [ :each | each isFunction ]
]

{ #category : 'testing' }
IGNamespace >> hasFunctions [

	^ self functions notEmpty
]

{ #category : 'testing' }
IGNamespace >> isNamespace [

	^ true
]

{ #category : 'accessing' }
IGNamespace >> originNamespaceName [
	
	^ String streamContents: [ :stream |
		originPath asStringOn: stream delimiter: '::' ]
]

{ #category : 'accessing' }
IGNamespace >> path [

	self flag: 'This is a problem if there are classes installed in an already installed namespace (this would be 
	annoying, but possible)'.
	^ (self root installedNamespaceFor: self) 
		ifNotNil: [ :aNamespace | { aNamespace cppPrefix }, (aNamespace cppName substrings: '::') ]
		ifNil: [ { self root prefix asLowercase }, originPath ]
]

{ #category : 'accessing' }
IGNamespace >> phDeclarationWith: aPrefix [

	^ (super phDeclarationWith: aPrefix), 'Namespace'

]
