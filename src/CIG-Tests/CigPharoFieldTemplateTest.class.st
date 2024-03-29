Class {
	#name : 'CigPharoFieldTemplateTest',
	#superclass : 'CigPharoBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateAnonymousUnionFieldDesc [
	| element template |

	element := self translatedUnitOpenSSL elementAtPath: { 'bio_poll_descriptor_st' }.
	template := (element fieldNamed: 'value') phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: 'bio_poll_descriptor_st_union1 value'
]

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateCallbackFieldDesc [
	| element template |

	element := self translatedUnitIcal elementAtPath: { 'sspm_action_map' }.
	template := (element fieldNamed: 'free_part') phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: 'FFICallback free_part'
]

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateConstCharPtrField [
	"const should be ignored"
	| element template |

	element := self translatedUnitOpenSSL elementAtPath: { 'srtp_protection_profile_st' }.
	template := (element fieldNamed: 'name') phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: 'char* name'
]

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateConstField [
	"const should be ignored"
	| element template |

	element := self translatedUnitIcal elementAtPath: { 'icaltimetype' }.
	template := (element fieldNamed: 'zone') phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: 'icaltimezone* zone'
]

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateExistingStructFieldDesc [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'fLink' }.
	template := element fields first phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: 'xx_fLink* f'
]

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateSimpleFieldDesc [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TResourceItem' }.
	template := element fields first phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: 'int32_t pos'
]

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateUnionFieldDesc [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'MessageEvent' }.
	template := element fields second phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: 'XxMessageEventUnion1 union1'
]

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateUnionInsideFieldDesc [
	| element template |

	element := self translatedUnitOpenSSL elementAtPath: { 'lhash_st_ERR_STRING_DATA' }.
	template := (element fieldNamed: 'dummy') phTemplate.
	
	"Yes, is ugly and long but is an union with ugly name inside 
	 a struct with another ugly name"
	self 
		assert: template generateFieldDesc
		equals: 'lhash_st_ERR_STRING_DATA_lh_ERR_STRING_DATA_dummy dummy'
]

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateUnsignedCharFieldDesc [
	| element template |

	element := self translatedUnitRaylib elementAtPath: { 'Color' }.
	template := element fields first phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: 'uchar r'
]

{ #category : 'tests' }
CigPharoFieldTemplateTest >> testGenerateUnsignedShortFieldDesc [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'ffblk' }.
	template := element fields fourth phTemplate.
	
	"maps to xx_ushort because in this case there is a typedef that defines ushort :)" 
	self 
		assert: template generateFieldDesc
		equals: 'xx_ushort ff_ftime'
]
