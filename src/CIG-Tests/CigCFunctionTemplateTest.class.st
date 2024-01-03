Class {
	#name : 'CigCFunctionTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C-Template',
	#package : 'CIG-Tests',
	#tag : 'C-Template'
}

{ #category : 'tests' }
CigCFunctionTemplateTest >> testGenerateBodyBasicTypeFunctionWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getStyle(const TColorAttr &)' }.
	template := CigCFunctionTemplate for: element.
		
	self 
		assert: template generateBody trimmed
		equals: 'return getStyle(*(TColorAttr*)attr);'
]

{ #category : 'tests' }
CigCFunctionTemplateTest >> testGenerateBodyFunctionWithReturnClassReferenceOverloadNew [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getFore(const TColorAttr &)' }.
	template := CigCFunctionTemplate for: element.
		
	self 
		assert: template generateBody trimmed
		equals: '*(TColorDesired*)result = getFore(*(TColorAttr*)attr);'
]

{ #category : 'tests' }
CigCFunctionTemplateTest >> testGenerateBodyIntFunctionWithParameterInt [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'min(int, int)' }.
	template := CigCFunctionTemplate for: element.
		
	self 
		assert: template generateBody trimmed
		equals: 'return min(a, b);'
]

{ #category : 'tests' }
CigCFunctionTemplateTest >> testGenerateBodyVoidFunctionWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'setStyle(TColorAttr &, ushort)' }.
	template := CigCFunctionTemplate for: element.
		
	self 
		assert: template generateBody trimmed
		equals: 'setStyle(*(TColorAttr*)attr, style);'
]

{ #category : 'tests' }
CigCFunctionTemplateTest >> testGenerateFunctionVoidFunctionWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'setStyle(TColorAttr &, ushort)' }.
	template := CigCFunctionTemplate for: element.
		
	self 
		assert: template generate
		equals: 'void tv_setStyle(tv_TColorAttr* attr, tv_ushort style) {
	setStyle(*(TColorAttr*)attr, style);
}'
]

{ #category : 'tests' }
CigCFunctionTemplateTest >> testGenerateHeaderFunctionWithReturnClassReferenceOverloadNew [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'getFore(const TColorAttr &)' }.
	template := CigCFunctionTemplate for: element.
		
	self 
		assert: template generateHeader
		equals: 'void tv_getFore(tv_TColorAttr* attr, tv_TColorDesired* result)'
]

{ #category : 'tests' }
CigCFunctionTemplateTest >> testGenerateHeaderVoidFunctionWithParameterClassReference [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'setStyle(TColorAttr &, ushort)' }.
	template := CigCFunctionTemplate for: element.
		
	self 
		assert: template generateHeader
		equals: 'void tv_setStyle(tv_TColorAttr* attr, tv_ushort style)'
]
