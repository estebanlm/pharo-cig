Class {
	#name : 'CigPharoTypedefTemplateTest',
	#superclass : 'CigPharoBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'tests' }
CigPharoTypedefTemplateTest >> testVisitTypedefWithStruct [
	| element template |

	element := self translatedUnitOpenSSL elementAtPath: { 'ssl_crock_st' }.	
	template := element phTemplate.

	self 
		assert: template generate
		equals: 'ssl_crock_st'.	
]
