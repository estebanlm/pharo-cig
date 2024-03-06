Class {
	#name : 'CigTypedefTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigTypedefTest >> testIsHomonym [
	| element |
	
	element := self translatedUnitRaylib 
		findElementMatching: [ :anElement | 
			anElement kind = CigTypedef kind
			and: [ anElement name = 'Vector2' ] ].
		
	self assert: element isHomonym
]
