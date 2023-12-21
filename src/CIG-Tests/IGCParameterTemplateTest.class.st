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
	
	self assert: (template castReturn: 'x') equals: '(tv_ushort)(x)'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testCastReturnClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getAttr(const TScreenCell &)' }.
	template := IGCParameterTemplate forReturn: element.
	
	self assert: (template castReturn: 'x') equals: '(tv_TColorAttr*)(x)'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testCastReturnStructPointerType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { '_dos_findnext(struct find_t *)' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self assert: (template castReturn: 'x') equals: '(struct tv_find_t*)(x)'
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
IGCParameterTemplateTest >> testGenerateFieldClass [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'fLink'. 'forceLink' }.
	template := IGCParameterTemplate forField: element.
	
	self assert: template generate equals: 'tv_TStreamableClass* forceLink'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateReferenceArgument [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TText'. 'scroll(TStringView, int, Boolean)' }.
	template := element parameters first cTemplate.
	
	self 
		assert: template generateArgument
		equals: '*(TStringView*)text'
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testGenerateSelfType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'TView' }.
	template := IGCParameterSelfTemplate for: element.
	
	self assert: template generate equals: 'tv_TView* self'
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
IGCParameterTemplateTest >> testResolveBasicType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getCtrlChar(ushort)' }.
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
IGCParameterTemplateTest >> testResolveFieldClass [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'fLink'. 'forceLink' }.
	template := IGCParameterTemplate forField: element.
	
	self assert: template class equals: IGCParameterClassTemplate
]

{ #category : 'tests' }
IGCParameterTemplateTest >> testResolveStructType [
	| template element |

	element := self translatedUnitTvision elementAtPath: { '_dos_findnext(struct find_t *)' }.
	template := IGCParameterTemplate forParameter: element parameters first.
	
	self assert: template class equals: IGCParameterStructTypeTemplate
]
