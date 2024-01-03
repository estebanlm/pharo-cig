Class {
	#name : 'CigCClassTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C-Template',
	#package : 'CIG-Tests',
	#tag : 'C-Template'
}

{ #category : 'tests' }
CigCClassTemplateTest >> testGenerateClassTemplateHeader [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	template := CigCClassTemplate for: element.
	
	self 
		assert: template generateHeader
		equals: 'typedef void tv_TSpan;
typedef void tv_TSpanChar;
typedef void tv_TSpanTScreenCell;
typedef void tv_TSpanUint32_t;'
]

{ #category : 'tests' }
CigCClassTemplateTest >> testGenerateHeader [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TObject' }.
	template := CigCClassTemplate for: element.
	
	self 
		assert: template generateHeader
		equals: 'typedef void tv_TObject;'
]
