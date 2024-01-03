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
		detect: [ :eachElement | aBlock value: eachElement ]
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
CigTElementContainer >> inspectionElements [
	<inspectorPresentationOrder: 910 title: 'Elements'>
	
	^ SpTablePresenter new 
		beResizable;
		items: self elements;
		addColumn: ((SpStringTableColumn title: 'Type' evaluated: #className) 
			beSortable;
			width: 120;
			yourself);
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name) beSortable;
		yourself
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
