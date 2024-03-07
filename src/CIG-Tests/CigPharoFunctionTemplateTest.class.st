Class {
	#name : 'CigPharoFunctionTemplateTest',
	#superclass : 'CigPharoBaseTest',
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

	self ffiCall: #(void xx_fexpand_1(char* rpath))'
]

{ #category : 'tests' }
CigPharoFunctionTemplateTest >> testGenerateFunctionForCLibraryDoesNotGeneratesPrefix [
	| element template |

	element := self translatedUnitRaylib elementAtPath: { 'InitWindow(int, int, const char *)' }.
	template := element phTemplate.
	
	self 
		assert: template generate
		equals: 'initWindowWidth: width height: height title: title

	self ffiCall: #(void InitWindow(int width, int height, const char* title))'
]

{ #category : 'tests' }
CigPharoFunctionTemplateTest >> testGenerateMethod [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'getBounds()' }.
	template := element phTemplate.
	
	self 
		assert: template generate
		equals: 'getBounds

	self ffiCall: #(xx_TRect* xx_TView_getBounds(xx_TView* self))'
]

{ #category : 'tests' }
CigPharoFunctionTemplateTest >> testGenerateMethodWithResultAsArgument [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TView'. 'getColor(ushort)' }.
	template := element phTemplate.
	
	self 
		assert: template generate
		equals: 'getColor: color result: result

	self ffiCall: #(void xx_TView_getColor(xx_TView* self, xx_ushort color, xx_TAttrPair* result))'
]
