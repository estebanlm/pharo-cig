Class {
	#name : 'CigFieldTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

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
