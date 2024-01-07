Class {
	#name : 'CigNamespace',
	#superclass : 'CigElement',
	#instVars : [
		'originPath'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'instance creation' }
CigNamespace class >> fromCursor: aCursor [

	^ self new fromCursor: aCursor
]

{ #category : 'accessing' }
CigNamespace class >> kind [

	^ CXCursor_Namespace
]

{ #category : 'visiting' }
CigNamespace >> accept: aVisitor [

	aVisitor visitNamespace: self
]

{ #category : 'testing' }
CigNamespace >> acceptNestedClasses [

	^ true
]

{ #category : 'initialization' }
CigNamespace >> fromCursor: aCursor [

	super fromCursor: aCursor.
	originPath := aCursor withAllParents allButFirst collect: [ :each | each displayName ]
]

{ #category : 'accessing' }
CigNamespace >> functions [

	^ self elements select: [ :each | each isFunction ]
]

{ #category : 'testing' }
CigNamespace >> hasFunctions [

	^ self functions notEmpty
]

{ #category : 'testing' }
CigNamespace >> isNamespace [

	^ true
]

{ #category : 'accessing' }
CigNamespace >> originNamespaceName [
	
	^ String streamContents: [ :stream |
		originPath asStringOn: stream delimiter: '::' ]
]

{ #category : 'accessing' }
CigNamespace >> path [

	self flag: 'This is a problem if there are classes installed in an already installed namespace (this would be 
	annoying, but possible)'.
	^ (self root installedNamespaceFor: self) 
		ifNotNil: [ :aNamespace | { aNamespace cppPrefix }, (aNamespace cppName substrings: '::') ]
		ifNil: [ { self root prefix asLowercase }, originPath ]
]

{ #category : 'accessing' }
CigNamespace >> phDeclaration [

	^ String streamContents: [ :stream | 
		stream 
			<< self root prefix capitalized 
			<< self name capitalized
			<< 'Namespace' ]
]

{ #category : 'accessing' }
CigNamespace >> phDeclarationWith: aPrefix [

	^ (super phDeclarationWith: aPrefix), 'Namespace'

]
