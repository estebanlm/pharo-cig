Class {
	#name : 'IGCParameterTemplateTest',
	#superclass : 'IGCTemplateTest',
	#category : 'CIG-Tests-Template',
	#package : 'CIG-Tests',
	#tag : 'Template'
}

{ #category : 'tests' }
IGCParameterTemplateTest >> testCastReturnBasicType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getStyle(const TColorAttr &)' }.
	template := IGCParameterTemplate forReturn: element.
	
	self assert: (template castReturn: 'x') equals: 'return x'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testCastReturnClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'RGBtoBIOS(TColorRGB)' }.
	template := IGCParameterTemplate forReturn: element.
	
	self 
		assert: (template castReturn: 'x')  
		equals: 'auto _result = new TColorBIOS();
*_result = x;
return (tv_TColorBIOS*)_result'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testCastReturnClassReferencePassingReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TRect'. 'move(int, int)' }.
	template := IGCParameterTemplate forReturn: element.
	
	self 
		assert: (template castReturn: 'x')
		equals: 'return (tv_TRect*)&(x)'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testCastReturnConstBasic [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'historyStr(uchar, int)' }.
	template := IGCParameterTemplate forReturn: element.
	
	self assert: (template castReturn: 'x') equals: 'return (const char*)(x)'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testCastReturnStdStringType [
	| template element |

	element := self elementAtPath: { 'noise'. 'utils'. 'WriterBMP'. 'GetDestFilename()' }.
	template := IGCParameterTemplate forReturn: element.
	
	self assert: (template castReturn: 'x') equals: 'return (char*)(x).c_str()'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testCastReturnStructPointerType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { '_dos_findnext(struct find_t *)' }.
	template := element parameters first cTemplate.
	
	self assert: (template castReturn: 'x') equals: 'return (struct tv_find_t*)(x)'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateArgumentPointerClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TColorDialog'. 'getIndexes(TColorIndex *&)' }.
	template := element parameters first cTemplate.

	self 
		assert: template generateArgument 
		equals: '(TColorIndex*&)arg1'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateArgumentReferenceArgument [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TText'. 'next(TStringView, int &)' }.
	template := element parameters second cTemplate.
	
	self 
		assert: template generateArgument
		equals: '*index'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateArgumentStdString [
	| template element |

	element := self elementAtPath: { 'noise'. 'utils'. 'WriterBMP'. 'SetDestFilename(const std::string &)' }.
	template := element parameters first cTemplate.

	self 
		assert: template generateArgument 
		equals: 'std::string(filename)'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateArgumentWhenTypedefOfComplexElementAndPointer [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'printEventCode(ostream &, ushort)' }.
	template := element parameters first cTemplate.
	
	self 
		assert: template generateArgument
		equals: '*arg1'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateBasicType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getCtrlChar(ushort)' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self assert: template generate equals: 'tv_ushort arg1'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getStyle(const TColorAttr &)' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self assert: template generate equals: 'tv_TColorAttr* attr'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateClassSpecialization [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TStringView'. 'TStringView(TSpan<char>)' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self 
		assert: template generateArgument 
		equals: '*(TSpan<char>*)span'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateFieldClass [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'fLink'. 'forceLink' }.
	template := IGCParameterTemplate forField: element.
	
	self assert: template generate equals: 'tv_TStreamableClass* forceLink'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateFunctionArgument [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'requestClipboardText(void (&)(TStringView))' }.
	template := element parameters first cTemplate.
	
	self 
		assert: template generateArgument 
		equals: '(void (&)(TStringView))accept'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateFunctionArgumentWithTypedef [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TNSCollection'. 'firstThat(ccTestFunc, void *)' }.
	template := element parameters first cTemplate.
	
	self 
		assert: template generateArgument 
		equals: '(ccTestFunc)Test'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateFunctionParameter [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'requestClipboardText(void (&)(TStringView))' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self assert: template generate equals: 'void* accept'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateNestedEnum [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'getPlatform()' }.
	template := IGCParameterTemplate forReturn: element.
	
	self assert: template generateCType equals: 'tv_THardwareInfo_PlatformType'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateNestedEnumParameter [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TGroup'. 'setCurrent(TView *, selectMode)' }.
	template := IGCParameterTemplate forParameter: element parameters second.
	
	self assert: template generate equals: 'tv_TView_selectMode mode'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateNestedEnumType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'getPlatform()' }.
	template := IGCParameterTemplate forReturn: element.
	
	self assert: template generateCType equals: 'tv_THardwareInfo_PlatformType'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateSelfArgumentForClassWithinNamespace [
	| template element |

	element := self elementAtPath: { 'noise'.  'module'. 'Module'. 'GetSourceModule(int)' }.
	template := element cTemplate selfTemplate.
	
	self 
		assert: template generateArgument
		equals: '*(noise::module::Module*)Module'
	
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateSelfType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView' }.
	template := IGCParameterSelfTemplate for: element.
	
	self 
		assert: template generate 
		equals: 'tv_TView* self'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateStructPointerArgument [
	| template element |
	
	element := self translatedUnitTvision elementAtPath: { '_dos_findnext(struct find_t *)' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self 
		assert: template generateArgument
		equals: '(struct find_t*)__finfo'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateStructPointerType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { '_dos_findnext(struct find_t *)' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self assert: template generate equals: 'struct tv_find_t* __finfo'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateStructReferenceArgument [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'getMouseEvent(MouseEventType &)' }.
	template := element parameters first cTemplate.
	
	self 
		assert: template generateArgument
		equals: '*(struct MouseEventType*)event'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testResolveBasicType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'min(int, int)' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self assert: template class equals: IGCParameterBasicTypeTemplate
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testResolveClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getStyle(const TColorAttr &)' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self assert: template class equals: IGCParameterClassReferenceTemplate
	
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testResolveDeclarationType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getCtrlChar(ushort)' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self assert: template class equals: IGCParameterDeclarationTemplate
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testResolveFieldClass [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'fLink'. 'forceLink' }.
	template := IGCParameterTemplate forField: element.
	
	self assert: template class equals: IGCParameterClassPointerTemplate
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testResolvePointerToStructType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { '_dos_findnext(struct find_t *)' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self assert: template class equals: IGCParameterPointerToStructTypeTemplate
]
