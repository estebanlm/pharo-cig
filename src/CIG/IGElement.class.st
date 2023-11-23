Class {
	#name : 'IGElement',
	#superclass : 'Object',
	#traits : 'IGTElementContainer',
	#classTraits : 'IGTElementContainer classTrait',
	#instVars : [
		'name',
		'parent',
		'kind'
	],
	#pools : [
		'CXCursorKind'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGElement class >> allNodes [

	^ self allSubclasses reject: [ :each | each kind isNil ]
]

{ #category : 'instance creation' }
IGElement class >> fromCursor: aCursor [

	^ self new fromCursor: aCursor
]

{ #category : 'accessing' }
IGElement class >> kind [
	
	^ self subclassResponsibility
]

{ #category : 'accessing' }
IGElement class >> nodesDictionary [

	^ self allNodes
		collect: [ :each | each kind -> each ]
		as: IdentityDictionary
]

{ #category : 'comparing' }
IGElement >> = other [

	^ self species = other species 
		and: [ self name = other name ]
]

{ #category : 'visiting' }
IGElement >> accept: aVisitor [

	self subclassResponsibility
]

{ #category : 'accessing' }
IGElement >> addElement: anElement [

	elements ifNil: [ elements := OrderedCollection new ].
	anElement parent: self.
	elements add: anElement
]

{ #category : 'accessing' }
IGElement >> findElementMatching: aBlock [

	^ (aBlock value: self)
		ifTrue: [ self ]
		ifFalse: [ nil ]
]

{ #category : 'initialization' }
IGElement >> fromCursor: aCursor [

	name := aCursor displayName.
	kind := aCursor kind
]

{ #category : 'comparing' }
IGElement >> hash [

	^ self species hash bitXor: self name hash
]

{ #category : 'accessing' }
IGElement >> kind [

	^ kind
]

{ #category : 'accessing' }
IGElement >> name [

	^ name
]

{ #category : 'accessing' }
IGElement >> name: aString [

	name := aString
]

{ #category : 'accessing' }
IGElement >> parent [

	^ parent
]

{ #category : 'accessing' }
IGElement >> parent: anElement [

	parent := anElement
]

{ #category : 'printing' }
IGElement >> printOn: stream [

	super printOn: stream.
	stream << '(' << self name << ')'
]

{ #category : 'accessing' }
IGElement >> root [

	^ self parent 
		ifNotNil: [ self parent root ]
		ifNil: [ self ]
]
