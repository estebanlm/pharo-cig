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

{ #category : 'instance creation' }
CigNamespace class >> newName: aName path: aPath [

	^ (self newName: aName)
		originPath: aPath;
		yourself
	
]

{ #category : 'visiting' }
CigNamespace >> accept: aVisitor [

	aVisitor visitNamespace: self
]

{ #category : 'testing' }
CigNamespace >> acceptDataStructures [

	^ true
]

{ #category : 'visiting' }
CigNamespace >> acceptNameGenerator: aVisitor [

	^ aVisitor visitNamespace: self
]

{ #category : 'initialization' }
CigNamespace >> fromCursor: aCursor [

	super fromCursor: aCursor.
	originPath := aCursor lexicalPath
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
		originPath 
			do: [ :each | stream nextPutAll: each asString ] 
			separatedBy: [ stream nextPutAll: '::' ] ]
]

{ #category : 'initialization' }
CigNamespace >> originPath: aPath [

	originPath := aPath
]

{ #category : 'accessing' }
CigNamespace >> path [

	self flag: 'This is a problem if there are classes installed in an already 
	installed namespace (this would be annoying, but possible)'.
	^ (self root installedNamespaceFor: self) 
		ifNotNil: [ :aNamespace | { aNamespace cppPrefix }, (CigType toTypePath: aNamespace cppName) ]
		ifNil: [ { self root prefix asLowercase }, originPath ]
]
