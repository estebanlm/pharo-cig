Class {
	#name : 'CigParameterTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigParameterTest >> testParameterSizeTAnswerSizeTType [
	"there is a problem where size_t is being translated as int. 
	 this is an indirect test, since I am checking after the parse is done (but cost of 
	 parsing a full file just to test is prohibitive)"
	| element param |
			
	element := self translatedUnitTvision elementAtPath: { 'TText'. 'next(TStringView, int &)' }.
	param := element parameters second.
	
	self assert: param typeName equals: 'size_t &'
]
