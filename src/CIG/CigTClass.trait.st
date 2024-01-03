Trait {
	#name : 'CigTClass',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'testing' }
CigTClass >> hasOperatorOverload: aString [

	^ (self operatorAt: aString) notNil
]

{ #category : 'testing' }
CigTClass >> hasOperatorOverloadDelete [

	^ self hasOperatorOverload: 'delete'
]

{ #category : 'testing' }
CigTClass >> hasOperatorOverloadNew [

	^ self hasOperatorOverload: 'new'
]

{ #category : 'testing' }
CigTClass >> hasOperatorOverloadNewManyArguments [

	^ (self hasOperatorOverload: 'new') 
		and: [ (self operatorAt: 'new') parameters size > 1 ]
]

{ #category : 'accessing' }
CigTClass >> methods [

	^ self elements select: [ :each | each isMethod ]
]

{ #category : 'accessing' }
CigTClass >> operatorAt: aName [

	^ self operatorAt: aName
		ifFound: [ :aParam | aParam ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
CigTClass >> operatorAt: aName ifFound: foundBlock ifNone: noneBlock [

	^ self operators
		detect: [ :each | each operator = aName ]
		ifFound: foundBlock
		ifNone: noneBlock
]

{ #category : 'accessing' }
CigTClass >> operatorDelete [

	^ self operatorAt: 'delete'
]

{ #category : 'accessing' }
CigTClass >> operatorNew [

	^ self operatorAt: 'new'
]

{ #category : 'accessing' }
CigTClass >> operators [

	^ self elements select: [ :each | each isMethod and: [ each isOperator ] ]
]

{ #category : 'testing' }
CigTClass >> shouldExposeDispose [
	
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
