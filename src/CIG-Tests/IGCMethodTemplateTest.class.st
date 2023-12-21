Class {
	#name : 'IGCMethodTemplateTest',
	#superclass : 'IGCTemplateTest',
	#category : 'CIG-Tests-Template',
	#package : 'CIG-Tests',
	#tag : 'Template'
}

{ #category : 'tests' }
IGCMethodTemplateTest >> testGenerateBodyConstructor [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'TView(const TRect &)' }.
	template := element cTemplate.
	
	self 
		assert: template generateBody
		equals: 'return (tv_TView*)(new TView(*(TRect*)bounds));'
]

{ #category : 'tests' }
IGCMethodTemplateTest >> testGenerateBodyDispose [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TText' }.
	template := element cDisposeTemplate.
	
	self 
		assert: template generateBody
		equals: 'delete (TText*)self;'
]

{ #category : 'tests' }
IGCMethodTemplateTest >> testGenerateBodyStatic [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TText'. 'scroll(TStringView, int, Boolean)' }.
	template := element cTemplate.
	
	self 
		assert: template generateBody
		equals: 'return TText::scroll(*(TStringView*)text, count, (Boolean)includeIncomplete);'
]

{ #category : 'tests' }
IGCMethodTemplateTest >> testGenerateBodyVoidMethodWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'locate(TRect &)' }.
	template := IGCMethodTemplate for: element.
		
	self 
		assert: template generateBody
		equals: '((TView*)self)->locate(*(TRect*)bounds);'
]

{ #category : 'tests' }
IGCMethodTemplateTest >> testGenerateBodyVoidMethodWithouthParameters [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'hide()' }.
	template := IGCMethodTemplate for: element.
		
	self 
		assert: template generateBody
		equals: '((TView*)self)->hide();'
]

{ #category : 'tests' }
IGCMethodTemplateTest >> testGenerateHeaderConstructor [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'TView(const TRect &)' }.
	template := element cTemplate.
	
	self 
		assert: template generateHeader 
		equals: 'tv_TView* tv_TView_new_1(tv_TRect* bounds)'
]

{ #category : 'tests' }
IGCMethodTemplateTest >> testGenerateHeaderDispose [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TText' }.
	template := element cDisposeTemplate.
	
	self 
		assert: template generateHeader 
		equals: 'void tv_TText_dispose(tv_TText* self)'
]

{ #category : 'tests' }
IGCMethodTemplateTest >> testGenerateHeaderStatic [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TText'. 'scroll(TStringView, int, Boolean)' }.
	template := element cTemplate.
	
	self 
		assert: template generateHeader 
		equals: 'int tv_TText_scroll_1(tv_TStringView* text, int count, tv_Boolean includeIncomplete)'
]

{ #category : 'tests' }
IGCMethodTemplateTest >> testGenerateHeaderVoidMethodWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'locate(TRect &)' }.
	template := IGCMethodTemplate for: element.
		
	self 
		assert: template generateHeader
		equals: 'void tv_TView_locate(tv_TView* self, tv_TRect* bounds)'
]

{ #category : 'tests' }
IGCMethodTemplateTest >> testGenerateHeaderVoidMethodWithouthParameters [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'hide()' }.
	template := IGCMethodTemplate for: element.
		
	self 
		assert: template generateHeader
		equals: 'void tv_TView_hide(tv_TView* self)'
]
