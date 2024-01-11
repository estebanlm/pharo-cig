Class {
	#name : 'CigCTypedefTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateAliasBasicType [
	| element template |

	element := self translatedUnitFinalcut elementAtPath: { 'uShort' }.
	template := element cTemplate.
	
	self 
		assert: template generate
		equals: 'typedef unsigned short fc_uShort;'
]

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateArrayType [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TScrollChars' }.
	template := CigCTypedefTemplate for: element.
	
	self 
		assert: template generate
		equals: 'typedef char* tv_TScrollChars;'
]

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateBasicType [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'ushort' }.
	template := CigCTypedefTemplate for: element.
	
	self 
		assert: template generate
		equals: 'typedef unsigned short tv_ushort;'
]

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateClassTemplateFunctionType [
	| element template |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FVTerm'. 'FPreprocessingHandler' }.
	template := element cTemplate.
	
	self 
		assert: template generate
		equals: 'typedef void* fc_finalcut_FVTerm_FPreprocessingHandler;'
]

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateClassTemplateFunctionTypeFromStdFunction [
	| element template |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'handler_t' }.
	template := element cTemplate.
	
	self 
		assert: template generate
		equals: 'typedef void* fc_finalcut_handler_t;'
]

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateFunctionType [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TEditorDialog' }.
	template := CigCTypedefTemplate for: element.
	
	self 
		assert: template generate
		equals: 'typedef void* tv_TEditorDialog;'
]

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateNestedAliasBasicType [
	| element template |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FUnicode' }.
	template := element cTemplate.
	
	self 
		assert: template generate
		equals: 'typedef std::array<wchar_t, finalcut::UNICODE_MAX> fc_finalcut_FUnicode;'
]

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateNestedAliasClassTemplateWithVariableType [
	| element template |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FUnicode' }.
	template := element cTemplate.
	
	"this is std::array<wchar_t, UNICODE_MAX>
	 so. UNICODE_MAX = 5"
	self 
		assert: template generate
		equals: 'typedef std::array<wchar_t, finalcut::UNICODE_MAX> fc_finalcut_FUnicode;'
]

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateNestedClassTemplate [
	| element template |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FRingBuffer<T, Capacity>'. 'ring_iterator<Type, N>'. 'iterator_category' }.
	template := element cTemplate.
	
	self 
		assert: template generate
		equals: 'typedef std::forward_iterator_tag fc_finalcut_FRingBuffer_ring_iterator_iterator_category;'
]

{ #category : 'tests' }
CigCTypedefTemplateTest >> testGenerateScopedType [
	| element template |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FOutput'. 'FSetPalette' }.
	template := element cTemplate.
	
	self 
		assert: template generate
		equals: 'typedef finalcut::FColorPalette::FSetPalette fc_finalcut_FOutput_FSetPalette;'
]
