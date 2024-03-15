Class {
	#name : 'CigPharoFieldTemplateTest',
	#superclass : 'CigPharoBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

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
