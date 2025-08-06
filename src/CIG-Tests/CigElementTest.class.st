Class {
	#name : 'CigElementTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigElementTest class >> resources [

	^ { CigTestResource }
]

{ #category : 'tests' }
CigElementTest >> testClassCDeclaration [
	| element |

	element := self translatedUnitNoise elementAtPath: { 'noise'. 'module'. 'Module' }.

	self assert: element cDeclaration equals: 'no_noise_module_Module*'
]

{ #category : 'tests' }
CigElementTest >> testClassCPPDeclaration [
	| element |

	element := self translatedUnitNoise elementAtPath: { 'noise'. 'module'. 'Module' }.

	self assert: element cppDeclaration equals: 'noise::module::Module'
]

{ #category : 'tests' }
CigElementTest >> testElementAtPathFindElementOnOtherNamespace [
	| template element namespaceElement |

	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'NoiseMapBuilder'. 'SetSourceModule(const module::Module &)' }.
	template := element parameters first.
	namespaceElement := self translatedUnitNoiseutils elementAtPath:  template resolveType typeReferenceForParsedType namePath.
	
	self assert: namespaceElement notNil.
	self assert: namespaceElement cDeclaration equals: 'no_noise_module_Module*'
]

{ #category : 'tests' }
CigElementTest >> testFullNameWithAnswerCorrectName [
	| element |
		
	"class without namespace"
	element := self translatedUnitTvision elementAtPath: { 'TCellChar' }.
	self 
		assert: (element fullNameWith: '_')
		equals: 'tv_TCellChar'.

	"class with namespace"
	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'NoiseMap' }.
	self 
		assert: (element fullNameWith: '_')
		equals: 'nu_noise_utils_NoiseMap'.
		
	"class on different library (installed as a namespace)"
	element := self translatedUnitNoise elementAtPath: { 'noise'. 'module'. 'Module' }.
	self 
		assert: (element fullNameWith: '_')
		equals: 'no_noise_module_Module'
]

{ #category : 'tests' }
CigElementTest >> testSanitizeName [
	| element |

	element := CigElement basicNew.
	element parent: self translatedUnitNoise.
	
	"Whatever"
	self assert: (element sanitizeName: 'ab') equals: 'Ab'.
	"same prefix"
	self assert: (element sanitizeName: 'NoNoOther') equals: 'NoOther'.
	"same prefix, but one lowercase (so, no match)"
	self assert: (element sanitizeName: 'Nonoother') equals: 'Nonoother'.
	"let's see if NoNoiseNamespace is generated correctly"
	element := self translatedUnitNoise elementAtPath: { 'noise' }.
	self flag: #TODO. "I am not sure if this test is correct anymore, I am still uncertain on 
	force prefix for namespaces or not... for now I take it off"
	"self assert: element phDeclaration equals: 'NoNoiseNamespace'."
	"same prefix and underscore"
	self assert: (element sanitizeName: 'no_cypher_st') equals: 'No_cypher_st'.
	
]

{ #category : 'tests' }
CigElementTest >> testStructureCDeclaration [
	| element |

	element := self translatedUnitNoise elementAtPath: { 'noise'. 'module'. 'ControlPoint' }.

	self assert: element cDeclaration equals: 'no_noise_module_ControlPoint'
]

{ #category : 'tests' }
CigElementTest >> testStructureCPPDeclaration [
	| element |

	element := self translatedUnitNoise elementAtPath: { 'noise'. 'module'. 'ControlPoint' }.
	
	self assert: element cppDeclaration equals: 'noise::module::ControlPoint'
]

{ #category : 'tests' }
CigElementTest >> testUnnamedArgumentAnswersAValidName [
	| element params |

	element := self translatedUnitTvision elementAtPath: { 'TEditor'. 'insertBuffer(const char *, uint, uint, Boolean, Boolean)' }.

	params := element parameters.
	self assert: params first name equals: 'arg1'.
	self assert: params second name equals: 'arg2'.
	self assert: params third name equals: 'arg3'.
	self assert: params fourth name equals: 'arg4'.
	self assert: params fifth name equals: 'arg5'.
	
]

{ #category : 'tests' }
CigElementTest >> testVisitMethodDeclaredWithoutArgumentNamesGeneratesDefaultNames [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'TEditor'. 'insertBuffer(const char *, uint, uint, Boolean, Boolean)' }.
	
	self 
		assert: element phDeclaration 
		equals: 'insertBufferArg1: arg1 arg2: arg2 arg3: arg3 arg4: arg4 arg5: arg5'
]
