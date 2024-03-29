Class {
	#name : 'CigTypedefTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigTypedefTest >> testDefinesFunction [
	| element |
	
	self flag: #TODO. "Add more cases!"
	"this will match with a regex"
	element := self translatedUnitOpenSSL elementAtPath: { 'asn1_ps_func' }.
	self assert: element definesFunction.
	
	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'NoiseMapCallback' }.
	self assert: element definesFunction.

]

{ #category : 'tests' }
CigTypedefTest >> testIsHomonym [
	| element |
	
	element := self translatedUnitRaylib 
		findElementMatching: [ :anElement | 
			anElement kind = CigTypedef kind
			and: [ anElement name = 'Vector2' ] ].
		
	self assert: element isHomonym
]
