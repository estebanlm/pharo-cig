Class {
	#name : 'CigCMethodTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C-Template',
	#package : 'CIG-Tests',
	#tag : 'C-Template'
}

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyConstructor [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'TView(const TRect &)' }.
	template := element cTemplate.
	
	self 
		assert: template generateBody trimmed
		equals: 'return (tv_TView*)(new TView(*(TRect*)bounds));'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyConstructorOverloadNew [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TScreenCell'. 'TScreenCell()' }.
	template := element cTemplate.
	
	self 
		assert: template generateBody trimmed
		equals: 'return (tv_TScreenCell*)(new (p) TScreenCell());'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyConstructorOverloadNewSingleParameter [
	"when new is overloaded but with just one parameter we can proceed as usual"
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TStreamableTypes'. 'TStreamableTypes()' }.
	template := element cTemplate.
	
	self 
		assert: template generateBody trimmed
		equals: 'return (tv_TStreamableTypes*)(new TStreamableTypes());'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyDispose [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TText' }.
	template := element cDisposeTemplate.
	
	self 
		assert: template generateBody trimmed
		equals: 'delete (TText*)self;'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyFunctionReturnClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'RGBtoBIOS(TColorRGB)' }.
	template := CigCFunctionTemplate for: element.
		
	self
		assert: template generateBody
		equals: 'auto _result = new TColorBIOS();
*_result = RGBtoBIOS(*(TColorRGB*)arg1);
return (tv_TColorBIOS*)_result;'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyMethodWithReturnClassReferenceOverloadNew [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'getColor(ushort)' }.
	template := CigCMethodTemplate for: element.
		
	self 
		assert: template generateBody
		equals: '*(TAttrPair*)result = ((TView*)self)->getColor(color);'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyReturnStruct [
	| element template |
	
	element := self translatedUnitTvision elementAtPath: { 'TText'. 'measure(TStringView)' }.
	template := element cTemplate.

	self 
		assert: template generateBody
		equals: 'auto _tmp = TText::measure(*(TStringView*)text);
struct tv_TTextMetrics _result;
memcpy(&_result, &_tmp, sizeof(struct tv_TTextMetrics));
return _result;'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyStatic [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TText'. 'scroll(TStringView, int, Boolean)' }.
	template := element cTemplate.
	
	self 
		assert: template generateBody trimmed
		equals: 'return TText::scroll(*(TStringView*)text, count, includeIncomplete);'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyStaticReturningClass [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'allocateScreenBuffer()' }.
	template := element cTemplate.
	
	self 
		assert: template generateBody trimmed
		equals: 'return (tv_TScreenCell*)(THardwareInfo::allocateScreenBuffer());'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyVoidMethodWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'locate(TRect &)' }.
	template := CigCMethodTemplate for: element.

	self 
		assert: template generateBody trimmed
		equals: '((TView*)self)->locate(*(TRect*)bounds);'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyVoidMethodWithParameterPointerClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TColorDialog'. 'getIndexes(TColorIndex *&)' }.
	template := CigCMethodTemplate for: element.

	self 
		assert: template generateBody trimmed
		equals: '((TColorDialog*)self)->getIndexes((TColorIndex*&)arg1);'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyVoidMethodWithParameterStructReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo'. 'getMouseEvent(MouseEventType &)' }.
	template := element cTemplate.
		
	self 
		assert: template generateBody trimmed
		equals: 'return THardwareInfo::getMouseEvent(*(struct MouseEventType*)event);'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateBodyVoidMethodWithouthParameters [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'hide()' }.
	template := CigCMethodTemplate for: element.
		
	self 
		assert: template generateBody trimmed
		equals: '((TView*)self)->hide();'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateHeaderConstructor [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'TView(const TRect &)' }.
	template := element cTemplate.
	
	self 
		assert: template generateHeader 
		equals: 'tv_TView* tv_TView_new_1(tv_TRect* bounds)'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateHeaderConstructorOverloadNew [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TScreenCell'. 'TScreenCell()' }.
	template := element cTemplate.
	
	self 
		assert: template generateHeader 
		equals: 'tv_TScreenCell* tv_TScreenCell_new_1(void* p)'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateHeaderDispose [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TText' }.
	template := element cDisposeTemplate.
	
	self 
		assert: template generateHeader 
		equals: 'void tv_TText_dispose(tv_TText* self)'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateHeaderMethodWithReturnClassReferenceOverloadNew [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'getColor(ushort)' }.
	template := CigCMethodTemplate for: element.
		
	self 
		assert: template generateHeader
		equals: 'void tv_TView_getColor(tv_TView* self, tv_ushort color, tv_TAttrPair* result)'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateHeaderStatic [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TText'. 'scroll(TStringView, int, Boolean)' }.
	template := element cTemplate.
	
	self 
		assert: template generateHeader 
		equals: 'int tv_TText_scroll_1(tv_TStringView* text, int count, tv_Boolean includeIncomplete)'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateHeaderVoidMethodWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'locate(TRect &)' }.
	template := CigCMethodTemplate for: element.
		
	self 
		assert: template generateHeader
		equals: 'void tv_TView_locate(tv_TView* self, tv_TRect* bounds)'
]

{ #category : 'tests' }
CigCMethodTemplateTest >> testGenerateHeaderVoidMethodWithouthParameters [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'hide()' }.
	template := CigCMethodTemplate for: element.
		
	self 
		assert: template generateHeader
		equals: 'void tv_TView_hide(tv_TView* self)'
]
