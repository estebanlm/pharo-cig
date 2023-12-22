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
IGParameterTest >> testParameterClassCastsCorrectly [
	"it will be a pointer in our case"
	| element visitor cast |
			
	element := self translatedUnitTvision elementAtPath: { 'TCellChar'. 'moveStr(TStringView, bool)'. 'mbc' }.
	
	visitor := IGVisitor newForTest.
	cast := (IGCClassGenerator on: visitor) argumentCastToCPP: element.
	
	self assert: cast equals: '*(TStringView*)mbc'
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
IGParameterTest >> testParameterReferenceTypeCastsCorrectly [
	| element param |

	element := self translatedUnitTvision elementAtPath: { 'TText'. 'scroll(TStringView, int, Boolean, int &, int &)' }.
	param := element parameters fourth.
	
	self assert: param resolveType cDeclaration equals: 'int*'.
	self assert: param resolveType cppDeclaration equals: 'int&'.
	
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
