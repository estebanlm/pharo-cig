Class {
	#name : 'CigFieldTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigFieldTest >> testResolveTypeForStructureWithoutTypeReferenceCreatesCorrectReference [ 
	| element type |
	
	element := self translatedUnitLibXML elementAtPath: #('_xmlDoc' 'dict').
	type := element resolveType.
	"It has to answer same element"
	self 
		assert: type element 
		identicalTo: (self translatedUnitLibXML elementAtPath: { '_xmlDict' })
]

{ #category : 'tests' }
CigFieldTest >> testSpecialField [
	| element |

	"I do not have (yet) an special field to test :("
	self skip.
	"just an int"
	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FTermData'. 'EncodingInfo'. 'encoding_list' }.
	self deny: element isSpecial.
	"a std::mutex"
	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FTermData'. 'SynchronizationState'. 'resize_mutex' }.
	self assert: element isSpecial.
	"a std::atomic<int>"
	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FTermData'. 'SynchronizationState'. 'resize_count' }.
	self assert: element isSpecial
]
