"
Adds element container capabilities, also ways to traverse and find specific elements.
"
Trait {
	#name : 'CigTElementContainer',
	#instVars : [
		'elements'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigTElementContainer >> addElement: anElement [

	elements ifNil: [ elements := OrderedCollection new ].
	anElement parent: self.
	elements add: anElement
]

{ #category : 'accessing' }
CigTElementContainer >> elements [

	^ elements ifNil: [ #() ]
]

{ #category : 'accessing' }
CigTElementContainer >> findDeepElementMatching: aBlock [

	self elements do: [ :eachElement |
		(eachElement findDeepElementMatching: aBlock) 
			ifNotNil: [ :found | ^ found ] ].

	^ nil
]

{ #category : 'private' }
CigTElementContainer >> findElementMatching: aBlock [

	^ self elements 
		detect: [ :eachElement | 
			"no types we don't know"
			eachElement isUnknown not
				"no type references"
				and: [ eachElement isTypeReference not
				"no namespaces"
				and: [ eachElement isNamespaceReference not 
				"now we can effectively search for them"
				and: [ aBlock value: eachElement ] ] ] ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
CigTElementContainer >> findElementMatchingCursor: aCursor [

	^ self elements 
		detect: [ :each | each matchesCursor: aCursor ]
		ifNone: [ nil ]
]

{ #category : 'testing' }
CigTElementContainer >> hasElements [

	^ elements isEmptyOrNil not
]

{ #category : 'inspecting' }
CigTElementContainer >> inspectionElements: aBuilder [
	<inspectorPresentationOrder: 910 title: 'Elements'>
	
	^ aBuilder newTable
		addStyle: 'stList';
		beResizable;
		items: self elements;
		addColumn: ((SpStringTableColumn title: 'Type' evaluated: #className) 
			beSortable;
			width: 120;
			yourself);
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name) beSortable;
		yourself
]

{ #category : 'accessing' }
CigTElementContainer >> scopeLookup: aString [

	^ self scopeLookupPath: (CigType toTypePath: aString)
]

{ #category : 'accessing' }
CigTElementContainer >> scopeLookupPath: aPath [

	^ (self elementAtPath: aPath)
		ifNil:[ self parent scopeLookupPath: aPath ]
]

{ #category : 'private - traversing' }
CigTElementContainer >> traverseElementsDo: aBlock [

	self 
		traverseElementsDo: aBlock 
		excluding: Set new	
]

{ #category : 'private - traversing' }
CigTElementContainer >> traverseElementsDo: aBlock excluding: excludes [

	(excludes includes: self) ifTrue: [ ^ self ]. 
	excludes add: self.
	aBlock value: self.

	self hasElements ifFalse: [ ^ self ]. 
	self elements do: [ :each |
		each traverseElementsDo: aBlock excluding: excludes ]
]
