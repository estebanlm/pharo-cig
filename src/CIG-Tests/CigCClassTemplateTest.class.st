Class {
	#name : 'CigCClassTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
CigCClassTemplateTest >> testGenerateHeader [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TObject' }.
	template := CigCClassTemplate for: element.
	
	self 
		assert: template generateHeader
		equals: 'typedef void tv_TObject;'
]
