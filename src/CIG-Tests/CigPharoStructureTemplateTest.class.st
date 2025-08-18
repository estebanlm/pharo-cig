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
CigPharoStructureTemplateTest >> testGenerateStructMultidimensionalArray [
	| unit element template |

	unit := self newUnit: '
typedef unsigned int IDEA_INT;
typedef struct idea_key_st {
    IDEA_INT data[9][6];
} IDEA_KEY_SCHEDULE;'.

	element := unit elements second.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	IDEA_INT_9_6 data
	)'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateStructSkipsAnonymousUnionInC [
	| element template |

	element := self translatedUnitOpenSSL elementAtPath: { 'bio_poll_descriptor_st' }.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	uint32_t type;
	bio_poll_descriptor_st_union1 value
	)'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateStructWithOpaqueObject [
	| element template |

	element := self translatedUnitLibXML elementAtPath: { '_xmlDoc' }.
	template := (element fieldNamed: 'dict') phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: '_xmlDict* dict'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateStructWithStructInDeclaration [
	| element template |

	element := self translatedUnitLibXML elementAtPath: { '_xmlNode' }.
	template := (element fieldNamed: 'children') phTemplate.
	
	self 
		assert: template generateFieldDesc
		equals: '_xmlNode* children'
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
CigPharoStructureTemplateTest >> testGenerateStructWithTypedefWithPointerToStructure [
	| element template |

	element := self translatedUnitLibXML elementAtPath: { '_xmlParserInputBuffer' }.
	template := (element fieldNamed: 'encoder') phTemplate.
	
	self 
		assert: template generateFieldDesc 
		equals: 'xmlCharEncodingHandlerPtr encoder'
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
CigPharoStructureTemplateTest >> testGenerateStructWithUnionAnonymous [
	| unit element template |

	unit := self newUnit: '
typedef long DES_LONG;
typedef unsigned char DES_cblock[8];
typedef struct DES_ks {
    union {
        DES_cblock cblock;
        DES_LONG deslong[2];
    } ks;
} DES_key_schedule;'.


	element := unit elements third.
	template := element phTemplate.
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	DES_ks_union1 ks
	)'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateStructWithUnionAnonymousAndArray [
	| unit element template |

	unit := self newUnit: '
typedef long DES_LONG;
typedef unsigned char DES_cblock[8];
typedef struct DES_ks {
    union {
        DES_cblock cblock;
        DES_LONG deslong[2];
    } ks[16];
} DES_key_schedule;'.

	element := unit elements third.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	DES_ks_union1_16 ks
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

	element := self translatedUnitRaylib elementAtPath: { 'Texture' }.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	uint id;
	int width;
	int height;
	int mipmaps;
	int format
	)'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateStructWithUnsignedChar [
	| element template |

	element := self translatedUnitRaylib elementAtPath: { 'Color' }.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	uchar r;
	uchar g;
	uchar b;
	uchar a
	)'
]

{ #category : 'tests' }
CigPharoStructureTemplateTest >> testGenerateStructWithUnsignedShort [
	| element template |

	element := self translatedUnitRaylib elementAtPath: { 'Mesh' }.
	template := element phTemplate.
	
	self 
		assert: template generateFieldsDesc
		equals: 'fieldsDesc

	^ #(
	int vertexCount;
	int triangleCount;
	float* vertices;
	float* texcoords;
	float* texcoords2;
	float* normals;
	float* tangents;
	uchar* colors;
	ushort* indices;
	float* animVertices;
	float* animNormals;
	uchar* boneIds;
	float* boneWeights;
	uint vaoId;
	uint* vboId
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
		equals: 'SslCipherSt'
]
