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
IGParameterTest >> testParameterClassInFunctionCastsCorrectly [
	"it will be a pointer in our case"
	| element visitor cast |
			
	element := self translatedUnitTvision elementAtPath: { 'historyAdd(uchar, TStringView)'. 'arg2' }.
	
	visitor := IGCVisitor newForTest.
	cast := (IGCGenerator on: visitor) argumentCastToCPP: element.
	
	self assert: cast equals: '*(TStringView*)arg2'
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