Class {
	#name : 'IGElementTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'accessing' }
IGElementTest class >> resources [

	^ { IGTestResource }
]

{ #category : 'tests' }
IGElementTest >> testClassCDeclaration [
	| element |

	element := self elementAtPath: { 'noise'. 'module'. 'Module' }.

	self assert: element cDeclaration equals: 'no_noise_module_Module*'
]

{ #category : 'tests' }
IGElementTest >> testClassCPPDeclaration [
	| element |

	element := self elementAtPath: { 'noise'. 'module'. 'Module' }.

	self assert: element cppDeclaration equals: 'noise::module::Module'
]

{ #category : 'tests' }
IGElementTest >> testFullNameWithAnswerCorrectName [
	| element |
		
	"class without namespace"
	element := self translatedUnitTvision elementAtPath: { 'TCellChar' }.
	self 
		assert: (element fullNameWith: '_')
		equals: 'tv_TCellChar'.

	"class with namespace"
	element := self elementAtPath: { 'noise'. 'utils'. 'NoiseMap' }.
	self 
		assert: (element fullNameWith: '_')
		equals: 'nu_noise_utils_NoiseMap'.
		
	"class on different library (installed as a namespace)"
	element := self elementAtPath: { 'noise'. 'module'. 'Module' }.
	self 
		assert: (element fullNameWith: '_')
		equals: 'no_noise_module_Module'.

]

{ #category : 'tests' }
IGElementTest >> testReferenceArgumentAnswersAsPointer [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'textEvent(TEvent &, TSpan<char>, int &)'. 'event' }.

	self 
		assert: element resolveType cDeclaration 
		equals: 'tv_TEvent*'
]

{ #category : 'tests' }
IGElementTest >> testStructureCDeclaration [
	| element |

	element := self elementAtPath: { 'noise'. 'module'. 'ControlPoint' }.

	self assert: element cDeclaration equals: 'no_noise_module_ControlPoint'
]

{ #category : 'tests' }
IGElementTest >> testStructureCPPDeclaration [
	| element |

	element := self elementAtPath: { 'noise'. 'module'. 'ControlPoint' }.
	
	self assert: element cppDeclaration equals: 'noise::module::ControlPoint'
]

{ #category : 'tests' }
IGElementTest >> testUnnamedArgumentAnswersAValidName [
	| element params |

	element := self translatedUnitTvision elementAtPath: { 'TEditor'. 'insertBuffer(const char *, uint, uint, Boolean, Boolean)' }.

	params := element parameters.
	self assert: params first name equals: 'arg1'.
	self assert: params second name equals: 'arg2'.
	self assert: params third name equals: 'arg3'.
	self assert: params fourth name equals: 'arg4'.
	self assert: params fifth name equals: 'arg5'.
	
]
