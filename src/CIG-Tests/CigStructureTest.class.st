Class {
	#name : 'CigStructureTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigStructureTest >> testEmptyStructureCanNOTBeExported [
	| element |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'TimerClass' }.
	self deny: element canBeExported
]

{ #category : 'tests' }
CigStructureTest >> testFieldsAnswerAlsoVariables [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'fLink' }.

	self assert: element fields size equals: 3
]

{ #category : 'tests' }
CigStructureTest >> testStructureWithAnonymousUnionArrayAndTypedef [
	"this struct will have an array of some anonynous union inside a struct which at 
	 time, will be put inside a typedef. "
	| unit element |
	
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
	self assert: element canBeExported
]

{ #category : 'tests' }
CigStructureTest >> testStructureWithClassInstanceTypeExportsAsClass [
	| element |

	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'GradientPoint' }.

	self assert: element isClass
]

{ #category : 'tests' }
CigStructureTest >> testStructureWithSpecialTypesExportsAsClass [
	| element |

	self skip. "I do not have an example right now :("

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FTermData'. 'SynchronizationState' }.

	"it can't be exported as this is in the private section"
	self deny: element canBeExported.
	"... but I test it anyway"
	self assert: element isClass
]
