Trait {
	#name : 'IGTClass',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGTClass >> methods [

	^ self elements select: [ :each | each isMethod ]
]

{ #category : 'accessing' }
IGTClass >> operatorAt: aName [

	^ self operatorAt: aName
		ifFound: [ :aParam | aParam ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
IGTClass >> operatorAt: aName ifFound: foundBlock ifNone: noneBlock [

	^ self operators
		detect: [ :each | each operator = aName ]
		ifFound: foundBlock
		ifNone: noneBlock
]

{ #category : 'accessing' }
IGTClass >> operators [

	^ self elements select: [ :each | each isMethod and: [ each isOperator ] ]
]
