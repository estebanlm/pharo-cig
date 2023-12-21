Class {
	#name : 'IGCFunctionTemplateTest',
	#superclass : 'IGCTemplateTest',
	#category : 'CIG-Tests-Template',
	#package : 'CIG-Tests',
	#tag : 'Template'
}

{ #category : 'tests' }
IGCFunctionTemplateTest >> testGenerateBodyBasicTypeFunctionWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getStyle(const TColorAttr &)' }.
	template := IGCFunctionTemplate for: element.
		
	self 
		assert: template generateBody trimmed
		equals: 'return (tv_ushort)(getStyle(*(TColorAttr*)attr));'
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
		equals: 'setStyle(*(TColorAttr*)attr, (ushort)style);'
]

{ #category : 'tests' }
IGCFunctionTemplateTest >> testGenerateFunctionVoidFunctionWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'setStyle(TColorAttr &, ushort)' }.
	template := IGCFunctionTemplate for: element.
		
	self 
		assert: template generate
		equals: 'void tv_setStyle(tv_TColorAttr* attr, tv_ushort style) {
	setStyle(*(TColorAttr*)attr, (ushort)style);
}'
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
