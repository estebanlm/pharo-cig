Class {
	#name : 'CigCParameterTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
CigCParameterTemplateTest >> testCastReturnBasicType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getStyle(const TColorAttr &)' }.
	template := CigCParameterTemplate forReturn: element.
	
	self assert: (template castReturn: 'x') equals: 'return x'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testCastReturnClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'RGBtoBIOS(TColorRGB)' }.
	template := CigCParameterTemplate forReturn: element.
	
	self 
		assert: (template castReturn: 'x')  
		equals: 'auto _result = new TColorBIOS();
*_result = x;
return (tv_TColorBIOS*)_result'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testCastReturnClassReferencePassingReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TRect'. 'move(int, int)' }.
	template := CigCParameterTemplate forReturn: element.
	
	self 
		assert: (template castReturn: 'x')
		equals: 'return (tv_TRect*)&(x)'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testCastReturnClassReferenceWithNamespace [
	| template element |

	element := self elementAtPath: { 'noise'. 'utils'. 'Image'. 'GetBorderValue()' }.
	template := CigCParameterTemplate forReturn: element.
	
	self 
		assert: (template castReturn: 'x')  
		equals: 'auto _result = new noise::utils::Color();
*_result = x;
return (nu_noise_utils_Color*)_result'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testCastReturnConstBasic [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'historyStr(uchar, int)' }.
	template := CigCParameterTemplate forReturn: element.
	
	self assert: (template castReturn: 'x') equals: 'return (const char*)(x)'
]

{ #category : 'tests - stdstring' }
CigCParameterTemplateTest >> testCastReturnStdStringType [
	| template element |

	element := self elementAtPath: { 'noise'. 'utils'. 'WriterBMP'. 'GetDestFilename()' }.
	template := CigCParameterTemplate forReturn: element.
	
	self 
		assert: (template castReturn: 'x') 
		equals: 'auto _tmp = x;
auto _result = _tmp.c_str();
return (char*)_result'
]

{ #category : 'tests - struct' }
CigCParameterTemplateTest >> testCastReturnStructPointerType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { '_dos_findnext(struct find_t *)' }.
	template := element parameters first cTemplate.
	
	self assert: (template castReturn: 'x') equals: 'return (struct tv_find_t*)(x)'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testGenerateArgumentClassSpecialization [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TText'. 'drawStr(TSpan<TScreenCell>, int, TStringView, int)' }.
	template := element parameters first cTemplate.
	
	self 
		assert: template generateArgument 
		equals: '*(TSpan<TScreenCell>*)cells'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testGenerateArgumentPointerClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TColorDialog'. 'getIndexes(TColorIndex *&)' }.
	template := element parameters first cTemplate.

	self 
		assert: template generateArgument 
		equals: '(TColorIndex*&)arg1'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testGenerateArgumentReferenceArgument [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TText'. 'next(TStringView, int &)' }.
	template := element parameters second cTemplate.
	
	self 
		assert: template generateArgument
		equals: '*index'
]

{ #category : 'tests - stdstring' }
CigCParameterTemplateTest >> testGenerateArgumentStdString [
	| template element |

	element := self elementAtPath: { 'noise'. 'utils'. 'WriterBMP'. 'SetDestFilename(const std::string &)' }.
	template := element parameters first cTemplate.

	self 
		assert: template generateArgument 
		equals: 'std::string(filename)'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testGenerateArgumentWhenTypedefOfComplexElementAndPointer [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'printEventCode(ostream &, ushort)' }.
	template := element parameters first cTemplate.
	
	self 
		assert: template generateArgument
		equals: '*arg1'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testGenerateBasicType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getCtrlChar(ushort)' }.
	template := CigCParameterTemplate forParameter: element parameters first.
	
	self assert: template generate equals: 'tv_ushort arg1'
]

{ #category : 'tests - callbacks' }
CigCParameterTemplateTest >> testGenerateCallback [
	| template element |

	element := self elementAtPath: { 'noise'. 'utils'. 'NoiseMapBuilder'. 'SetCallback(NoiseMapCallback)' }.
	template := element parameters first cTemplate.
	
	self 
		assert: template generate trimmed
		equals: 'nu_noise_utils_NoiseMapCallback pCallback'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testGenerateClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getStyle(const TColorAttr &)' }.
	template := CigCParameterTemplate forParameter: element parameters first.
	
	self assert: template generate equals: 'tv_TColorAttr* attr'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testGenerateClassSpecialization [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TStringView'. 'TStringView(TSpan<char>)' }.
	template := CigCParameterTemplate forParameter: element parameters first.
	
	self 
		assert: template generate 
		equals: 'tv_TSpan* span'
]

{ #category : 'tests - struct' }
CigCParameterTemplateTest >> testGenerateFieldClass [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'fLink'. 'forceLink' }.
	template := CigCParameterTemplate forField: element.
	
	self assert: template generate equals: 'tv_TStreamableClass* forceLink'
]

{ #category : 'tests - struct' }
CigCParameterTemplateTest >> testGenerateFunctionArgument [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'requestClipboardText(void (&)(TStringView))' }.
	template := element parameters first cTemplate.
	
	self 
		assert: template generateArgument 
		equals: '(void (&)(TStringView))accept'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testGenerateFunctionArgumentWithTypedef [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TNSCollection'. 'firstThat(ccTestFunc, void *)' }.
	template := element parameters first cTemplate.
	
	self 
		assert: template generateArgument 
		equals: '(ccTestFunc)Test'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testGenerateFunctionParameter [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'requestClipboardText(void (&)(TStringView))' }.
	template := CigCParameterTemplate forParameter: element parameters first.
	
	self assert: template generate equals: 'void* accept'
]

{ #category : 'tests - enum' }
CigCParameterTemplateTest >> testGenerateNestedEnum [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'getPlatform()' }.
	template := CigCParameterTemplate forReturn: element.
	
	self assert: template generateCType equals: 'tv_THardwareInfo_PlatformType'
]

{ #category : 'tests - enum' }
CigCParameterTemplateTest >> testGenerateNestedEnumParameter [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TGroup'. 'setCurrent(TView *, selectMode)' }.
	template := CigCParameterTemplate forParameter: element parameters second.
	
	self assert: template generate equals: 'tv_TView_selectMode mode'
]

{ #category : 'tests - enum' }
CigCParameterTemplateTest >> testGenerateNestedEnumType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'getPlatform()' }.
	template := CigCParameterTemplate forReturn: element.
	
	self assert: template generateCType equals: 'tv_THardwareInfo_PlatformType'
]

{ #category : 'tests - self' }
CigCParameterTemplateTest >> testGenerateSelfArgumentForClassWithinNamespace [
	| template element |

	element := self elementAtPath: { 'noise'.  'module'. 'Module'. 'GetSourceModule(int)' }.
	template := element cTemplate selfTemplate.
	
	self 
		assert: template generateArgument
		equals: '*(noise::module::Module*)Module'
	
]

{ #category : 'tests - self' }
CigCParameterTemplateTest >> testGenerateSelfType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView' }.
	template := CigCParameterSelfTemplate for: element.
	
	self 
		assert: template generate 
		equals: 'tv_TView* self'
]

{ #category : 'tests - struct' }
CigCParameterTemplateTest >> testGenerateStructPointerArgument [
	| template element |
	
	element := self translatedUnitTvision elementAtPath: { '_dos_findnext(struct find_t *)' }.
	template := CigCParameterTemplate forParameter: element parameters first.
	
	self 
		assert: template generateArgument
		equals: '(struct find_t*)__finfo'
]

{ #category : 'tests - struct' }
CigCParameterTemplateTest >> testGenerateStructPointerType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { '_dos_findnext(struct find_t *)' }.
	template := CigCParameterTemplate forParameter: element parameters first.
	
	self assert: template generate equals: 'struct tv_find_t* __finfo'
]

{ #category : 'tests - struct' }
CigCParameterTemplateTest >> testGenerateStructReferenceArgument [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'getMouseEvent(MouseEventType &)' }.
	template := element parameters first cTemplate.
	
	self 
		assert: template generateArgument
		equals: '*(struct MouseEventType*)event'
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testResolveBasicType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'min(int, int)' }.
	template := CigCParameterTemplate forParameter: element parameters first.
	
	self assert: template class equals: CigCParameterBasicTypeTemplate
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testResolveClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getStyle(const TColorAttr &)' }.
	template := CigCParameterTemplate forParameter: element parameters first.
	
	self assert: template class equals: CigCParameterClassReferenceTemplate
	
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testResolveClassSpecialzation [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TText'. 'drawStr(TSpan<TScreenCell>, int, TStringView, int)' }.
	template := element parameters first cTemplate.
	
	self assert: template class equals: CigCParameterClassSpecializationTemplate
	
]

{ #category : 'tests' }
CigCParameterTemplateTest >> testResolveDeclarationType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getCtrlChar(ushort)' }.
	template := CigCParameterTemplate forParameter: element parameters first.
	
	self assert: template class equals: CigCParameterDeclarationTemplate
]

{ #category : 'tests - struct' }
CigCParameterTemplateTest >> testResolveFieldClass [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'fLink'. 'forceLink' }.
	template := CigCParameterTemplate forField: element.
	
	self assert: template class equals: CigCParameterClassPointerTemplate
]

{ #category : 'tests - struct' }
CigCParameterTemplateTest >> testResolvePointerToStructType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { '_dos_findnext(struct find_t *)' }.
	template := CigCParameterTemplate forParameter: element parameters first.
	
	self assert: template class equals: CigCParameterPointerToStructTypeTemplate
]
