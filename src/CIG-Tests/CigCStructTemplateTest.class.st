Class {
	#name : 'CigCStructTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
CigCStructTemplateTest >> testGenerateSimpleStruct [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'ffblk' }.
	template := CigCStructTemplate for: element.
	
	self 
		assert: template generate 
		equals: 'struct tv_ffblk {
	int32_t ff_reserved;
	int32_t ff_fsize;
	uint32_t ff_attrib;
	unsigned ff_ftime;
	unsigned ff_fdate;
	char ff_name;
};'
]

{ #category : 'tests' }
CigCStructTemplateTest >> testGenerateStructWithAnonymousFields [
	| template element |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'TCapAttributes' }.
	template := element cTemplate.
	
	self 
		assert: template generate 
		equals: 'struct fc_finalcut_TCapAttributes {
	fc_uInt8 p1;
	fc_uInt8 p2;
	fc_uInt8 p3;
	fc_uInt8 p4;
	fc_uInt8 p5;
	fc_uInt8 p6;
	fc_uInt8 p7;
	fc_uInt8 p8;
	fc_uInt8 p9;
	fc_uInt8 noname_1;
};'
]

{ #category : 'tests' }
CigCStructTemplateTest >> testGenerateStructWithClasses [
	| template element |

	element := self translatedUnitTvision elementAtPath: { 'fLink' }.
	template := CigCStructTemplate for: element.
	
	self 
		assert: template generate 
		equals: 'struct tv_fLink {
	struct tv_fLink* f;
	tv_TStreamableClass* t;
	tv_TStreamableClass* forceLink;
};'
]
