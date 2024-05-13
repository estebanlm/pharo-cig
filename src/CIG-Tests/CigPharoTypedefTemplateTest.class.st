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

	element := self translatedUnitOpenSSL elementAtPath: { 'SSL_SESSION' }.	
	template := element phTemplate.

	self 
		assert: template generate
		equals: 'XxSsl_session_st'
]

{ #category : 'tests' }
CigPharoTypedefTemplateTest >> testVisitTypedefWithStructPointer [
	| element template |

	element := self translatedUnitOpenSSL elementAtPath: { 'ssl_crock_st' }.	
	template := element phTemplate.

	self 
		assert: template generate
		equals: 'XxSsl_st*'
]

{ #category : 'tests' }
CigPharoTypedefTemplateTest >> testVisitTypedefWithTypedefToStruct [
	| element template |

	element := self translatedUnitLibXML elementAtPath: { 'xmlBuffer' }.	
	template := element phTemplate.

	self 
		assert: template generate
		equals: 'Xx_xmlBuffer'
]

{ #category : 'tests' }
CigPharoTypedefTemplateTest >> testVisitTypedefWithTypedefToTypedefOfExistingStruct [
	| element template |

	element := self translatedUnitLibXML elementAtPath: { 'xmlCharEncodingHandlerPtr' }.	
	template := element phTemplate.

	self 
		assert: template generate
		equals: '#''xmlCharEncodingHandler *'''
]

{ #category : 'tests' }
CigPharoTypedefTemplateTest >> testVisitTypedefWithUnion [
	| element template |

	element := self translatedUnitOpenSSL elementAtPath: { 'BIO_ADDR' }.	
	template := element phTemplate.

	self 
		assert: template generate
		equals: 'XxBio_addr_st'
]