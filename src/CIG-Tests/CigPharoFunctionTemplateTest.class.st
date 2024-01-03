Class {
	#name : 'CigPharoFunctionTemplateTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'tests' }
CigPharoFunctionTemplateTest >> testGenerateFunction [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'fexpand(char *)' }.
	template := element phTemplate.
	
	self 
		assert: template generate
		equals: 'fexpand: rpath

	self ffiCall: #(void tv_fexpand_1(char* rpath))'
]

{ #category : 'tests' }
CigPharoFunctionTemplateTest >> testGenerateMethod [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'getBounds()' }.
	template := element phTemplate.
	
	self 
		assert: template generate
		equals: 'getBounds

	self ffiCall: #(tv_TRect* tv_TView_getBounds(tv_TView* self))'
]

{ #category : 'tests' }
CigPharoFunctionTemplateTest >> testGenerateMethodWithResultAsArgument [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'getColor(ushort)' }.
	template := element phTemplate.
	
	self 
		assert: template generate
		equals: 'getColor: color result: result

	self ffiCall: #(void tv_TView_getColor(tv_TView* self, tv_ushort color, tv_TAttrPair* result))'
]
