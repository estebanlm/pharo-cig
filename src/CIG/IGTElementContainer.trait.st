Trait {
	#name : 'IGTElementContainer',
	#instVars : [
		'elements'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
IGTElementContainer >> addElement: anElement [

	elements ifNil: [ elements := OrderedCollection new ].
	elements add: anElement
]

{ #category : 'accessing' }
IGTElementContainer >> elements [

	^ elements ifNil: [ #() ]
]

{ #category : 'accessing' }
IGTElementContainer >> findElementMatching: aBlock [

	self elements do: [ :eachElement |
		(eachElement findElementMatching: aBlock) 
			ifNotNil: [ :found | ^ found ] ].

	^ nil
]

{ #category : 'inspecting' }
IGTElementContainer >> inspectionElements [
	<inspectorPresentationOrder: 10 title: 'Elements'>
	
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
