Class {
	#name : 'IGCFunctionTemplateTest',
	#superclass : 'IGCTemplateTest',
	#category : 'CIG-Tests-C-Template',
	#package : 'CIG-Tests',
	#tag : 'C-Template'
}

{ #category : 'tests' }
IGCFunctionTemplateTest >> testGenerateBodyBasicTypeFunctionWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getStyle(const TColorAttr &)' }.
	template := IGCFunctionTemplate for: element.
		
	self 
		assert: template generateBody trimmed
		equals: 'return getStyle(*(TColorAttr*)attr);'
]

{ #category : 'tests' }
IGCFunctionTemplateTest >> testGenerateBodyFunctionWithReturnClassReferenceOverloadNew [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getFore(const TColorAttr &)' }.
	template := IGCFunctionTemplate for: element.
		
	self 
		assert: template generateBody trimmed
		equals: '*(TColorDesired*)result = getFore(*(TColorAttr*)attr);'
]

{ #category : 'tests' }
IGCFunctionTemplateTest >> testGenerateBodyIntFunctionWithParameterInt [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'min(int, int)' }.
	template := IGCFunctionTemplate for: element.
		
	self 
		assert: template generateBody trimmed
		equals: 'return min(a, b);'
]

{ #category : 'tests' }
IGCFunctionTemplateTest >> testGenerateBodyVoidFunctionWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'setStyle(TColorAttr &, ushort)' }.
	template := IGCFunctionTemplate for: element.
		
	self 
		assert: template generateBody trimmed
		equals: 'setStyle(*(TColorAttr*)attr, style);'
]

{ #category : 'tests' }
IGCFunctionTemplateTest >> testGenerateFunctionVoidFunctionWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'setStyle(TColorAttr &, ushort)' }.
	template := IGCFunctionTemplate for: element.
		
	self 
		assert: template generate
		equals: 'void tv_setStyle(tv_TColorAttr* attr, tv_ushort style) {
	setStyle(*(TColorAttr*)attr, style);
}'
]

{ #category : 'tests' }
IGCFunctionTemplateTest >> testGenerateHeaderFunctionWithReturnClassReferenceOverloadNew [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getFore(const TColorAttr &)' }.
	template := IGCFunctionTemplate for: element.
		
	self 
		assert: template generateHeader
		equals: 'void tv_getFore(tv_TColorAttr* attr, tv_TColorDesired* result)'
]

{ #category : 'tests' }
IGCFunctionTemplateTest >> testGenerateHeaderVoidFunctionWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'setStyle(TColorAttr &, ushort)' }.
	template := IGCFunctionTemplate for: element.
		
	self 
		assert: template generateHeader
		equals: 'void tv_setStyle(tv_TColorAttr* attr, tv_ushort style)'
]
