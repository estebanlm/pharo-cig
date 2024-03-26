Class {
	#name : 'CigPharoStructureTemplateTest',
	#superclass : 'CigPharoBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateSimpleStruct [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TResourceItem' }.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	int32_t pos;
	int32_t size;
	char* key
	)'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateStructWithStructure [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'fLink' }.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	xx_fLink* f;
	xx_TStreamableClass* t;
	xx_TStreamableClass* forceLink
	)'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateStructWithUnion [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'MessageEvent' }.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	xx_ushort command;
	XxMessageEventUnion1 union1
	)'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateStructWithUnionDefinitionSkipsDefinition [
	| element template |

	element := self translatedUnitOpenSSL elementAtPath: { 'lhash_st_ERR_STRING_DATA' }.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	lhash_st_ERR_STRING_DATA_lh_ERR_STRING_DATA_dummy dummy
	)'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateStructWithUnsigned [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'ffblk' }.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	int32_t ff_reserved;
	int32_t ff_fsize;
	uint32_t ff_attrib;
	uint ff_ftime;
	uint ff_fdate;
	char ff_name
	)'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testStructureNameDoesNotDuplicatesPrefix [
	| element |

	element := self translatedUnitOpenSSL 
		prefix: 'ssl';
		elementAtPath: { 'ssl_cipher_st' }.
	
	self 
		assert: element phDeclaration
		equals: 'Ssl_cipher_st'
]
