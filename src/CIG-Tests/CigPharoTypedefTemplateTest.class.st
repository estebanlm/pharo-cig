Class {
	#name : 'CigPharoTypedefTemplateTest',
	#superclass : 'CigPharoBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'tests' }
CigPharoTypedefTemplateTest >> testVisitTypedefWithFunction [
	"there is a difference between typedef 
		to function: int (something), 
		and to function pointer: int (*)(something)
	 the first case (that we test here) will be called as an opaque object (the declaration will add a 
	 pointer to give it arity of 1), e.g. 
	 long BIO_callback_ctrl(BIO* b, int cmd, BIO_info_cb* fp).
	 
	 FOR NOW, I am mapping that to void (to have a void* in the arguments), but I think I will need 
	 a special treatment so I can convert BIO_info_cb* to BIO_info_cb_ptr and then map it to a callback :/"
	| element template |

	self flag: #TODO. "review this (follow method comment guidelines)"
	element := self translatedUnitOpenSSL elementAtPath: { 'BIO_info_cb' }.	
	template := element phTemplate.

	self assert: template generate equals: '#void'
]

{ #category : 'tests' }
CigPharoTypedefTemplateTest >> testVisitTypedefWithFunctionPointer [
	"this is the other case of typedef to function, instead having a reference, we have a pointer to a function:
	 int (*)(...)"
	| element template |

	element := self translatedUnitOpenSSL elementAtPath: { 'SSL_custom_ext_add_cb_ex' }.	
	template := element phTemplate.

	self assert: template generate equals: 'FFICallback'
]

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
		equals: '#''ssl_st *'''
]

{ #category : 'tests' }
CigPharoTypedefTemplateTest >> testVisitTypedefWithTypedefToFunction [
	| element template |

	element := self translatedUnitOpenSSL elementAtPath: { 'bio_info_cb' }.	
	template := element phTemplate.

	self assert: template generate equals: 'BIO_info_cb'
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
CigPharoTypedefTemplateTest >> testVisitTypedefWithTypedefToTypedefOfPredefinedType [
	| element template |

	element := self translatedUnitOpenSSL elementAtPath: { 'CRYPTO_THREAD_ID' }.	
	template := element phTemplate.

	self 
		assert: template generate
		equals: 'pthread_t'
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
