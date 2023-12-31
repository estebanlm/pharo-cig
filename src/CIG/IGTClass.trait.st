Trait {
	#name : 'IGTClass',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'testing' }
IGTClass >> hasOperatorOverload: aString [

	^ (self operatorAt: aString) notNil
]

{ #category : 'testing' }
IGTClass >> hasOperatorOverloadDelete [

	^ self hasOperatorOverload: 'delete'
]

{ #category : 'testing' }
IGTClass >> hasOperatorOverloadNew [

	^ self hasOperatorOverload: 'new'
]

{ #category : 'testing' }
IGTClass >> hasOperatorOverloadNewManyArguments [

	^ (self hasOperatorOverload: 'new') 
		and: [ (self operatorAt: 'new') parameters size > 1 ]
]

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
IGTClass >> operatorDelete [

	^ self operatorAt: 'delete'
]

{ #category : 'accessing' }
IGTClass >> operatorNew [

	^ self operatorAt: 'new'
]

{ #category : 'accessing' }
IGTClass >> operators [

	^ self elements select: [ :each | each isMethod and: [ each isOperator ] ]
]

{ #category : 'testing' }
IGTClass >> shouldExposeDispose [
	
	"do not add dispose of abstract class"
	self isAbstract ifTrue: [ ^ false ].
	"if I have a new with arguments I will need to dispose differenly"
	self hasOperatorOverloadNewManyArguments ifTrue: [ ^ false ].
	
	"if destructor is private, the dispose method will not work."
	^ self elements 
		detect: [ :each | each isClassMember and: [ each isDestructor ] ] 
		ifFound: [ :aDestructor | aDestructor isPublic ]
		ifNone: [ true ]
]
