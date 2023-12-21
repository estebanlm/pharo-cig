Class {
	#name : 'IGCClassTemplateTest',
	#superclass : 'IGCTemplateTest',
	#category : 'CIG-Tests-Template',
	#package : 'CIG-Tests',
	#tag : 'Template'
}

{ #category : 'tests' }
IGCClassTemplateTest >> testGenerateClassTemplateHeader [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	template := IGCClassTemplate for: element.
	
	self 
		assert: template generateHeader
		equals: 'typedef void tv_TSpan;
typedef void tv_TSpanChar;
typedef void tv_TSpanTScreenCell;
typedef void tv_TSpanUint32_t;'
]

{ #category : 'tests' }
IGCClassTemplateTest >> testGenerateHeader [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TObject' }.
	template := IGCClassTemplate for: element.
	
	self 
		assert: template generateHeader
		equals: 'typedef void tv_TObject;'
]
