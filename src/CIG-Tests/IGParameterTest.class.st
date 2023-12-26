Class {
	#name : 'IGParameterTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'tests' }
IGParameterTest >> testParameterCallbackCastsCorrectly [
	| element |
			
	element := self translatedUnitTvision elementAtPath: { 'TGroup' . 'forEach(void (*)(TView *, void *), void *)' . 'func' }.
	
	self 
		assert: element resolveType cDeclaration
		equals: 'void*'
]

{ #category : 'tests' }
IGParameterTest >> testParameterClassSpecializationCastsCorrectly [
	| element param |

	element := self translatedUnitTvision elementAtPath: { 'TText'. 'drawStr(TSpan<TScreenCell>, int, TStringView, int)' }.
	param := element parameters first.
	
	self assert: param resolveType cDeclaration equals: 'tv_TSpanTScreenCell*'.
	self assert: param resolveType cppDeclaration equals: 'TSpan<TScreenCell>'.
	
]

{ #category : 'tests' }
IGParameterTest >> testParameterSizeTAnswerSizeTType [
	"there is a problem where size_t is being translated as int. 
	 this is an indirect test, since I am checking after the parse is done (but cost of 
	 parsing a full file just to test is prohibitive)"
	| element param |
			
	element := self translatedUnitTvision elementAtPath: { 'TText'. 'next(TStringView, int &)' }.
	param := element parameters second.
	
	self assert: param typeName equals: 'size_t &'
]
