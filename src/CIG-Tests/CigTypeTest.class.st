Class {
	#name : 'CigTypeTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigTypeTest >> testExtractAnonymousLocation [

	"test normal anonymous"
	self 
		assert: (CigType extractAnonymousLocation: 'union (unnamed at unit_0.h:5:5)')
		equals: 'unit_0.h:5:5'.
	"test array anonymous"
	self 
		assert: (CigType extractAnonymousLocation: 'union (unnamed at unit_0.h:5:5)[16]')
		equals: 'unit_0.h:5:5'.	
	"test not anonymous type answer nil"
	self assert: (CigType extractAnonymousLocation: 'struct myStruct') isNil.
	self assert: (CigType extractAnonymousLocation: 'struct myStruct[42]') isNil.
	self assert: (CigType extractAnonymousLocation: 'int') isNil.
	self assert: (CigType extractAnonymousLocation: 'int[42]') isNil
]

{ #category : 'tests' }
CigTypeTest >> testReplaceTypeClassTemplateTypeIn [
	| element result |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.

	result := CigType 
		replaceTypeClassTemplate: element
		type: 'char'
		in: 'TSpan<T> *'.
	self assert: result equals: 'TSpan<char>*'.
	
	result := CigType 
		replaceTypeClassTemplate: element
		type: 'char'
		in: 'TSpan<T>'.
	self assert: result equals: 'TSpan<char>'.

	result := CigType 
		replaceTypeClassTemplate: element
		type: 'char'
		in: 'TSpan<T>*'.
	self assert: result equals: 'TSpan<char>*'
]

{ #category : 'tests' }
CigTypeTest >> testReplaceTypeClassTemplateTypesIn [
	| element result |

	element := self translatedUnitStdArray elementAtPath: { 'std'. 'array<_Tp, _Nm>' }.

	result := CigType 
		replaceTypeClassTemplate: element
		types: { 'char'. 4 }
		in: 'array<_Tp, _Nm> *'.
	self assert: result equals: 'array<char, 4>*'.
	
	result := CigType 
		replaceTypeClassTemplate: element
		types: { 'char'. 4 }
		in: 'array<_Tp, _Nm>'.
	self assert: result equals: 'array<char, 4>'.

	result := CigType
		replaceTypeClassTemplate: element
		types: { 'char'. 4 }
		in: 'array<_Tp, _Nm>*'.
	self assert: result equals: 'array<char, 4>*'
]

{ #category : 'tests' }
CigTypeTest >> testReplaceTypeTemplateTypeIn [
	| element result |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.

	result := CigType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T *'.
	self assert: result equals: 'char*'.
	
	result := CigType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T'.
	self assert: result equals: 'char'.
	
	result := CigType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T*'.
	self assert: result equals: 'char*'.
	
	result := CigType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T &'.
	self assert: result equals: 'char&'.
	
	result := CigType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T&'.
	self assert: result equals: 'char&'.
	
	result := CigType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T *&'.
	self assert: result equals: 'char*&'
]

{ #category : 'tests' }
CigTypeTest >> testReplaceTypeTemplateTypes [
	| element result |

	element := self translatedUnitStdArray elementAtPath: { 'std'. 'array<_Tp, _Nm>' }.

	result := CigType 
		replaceTypeTemplate: element
		types: { 'char'. 'int' }
		in: '_Tp *'.
	self assert: result equals: 'char*'.
	
	result := CigType 
		replaceTypeTemplate: element
		types: { 'char'. 'int' }
		in: '_Nm *'.
	self assert: result equals: 'int*'
]

{ #category : 'tests' }
CigTypeTest >> testResolveFFIType [

	self assert: (CigType resolveFFIType: 'unsigned') equals: #uint.
	self assert: (CigType resolveFFIType: 'unsigned long') equals: #ulong.
	self assert: (CigType resolveFFIType: 'unsigned int') equals: #uint.
	self assert: (CigType resolveFFIType: 'unsigned short') equals: #ushort.
	self assert: (CigType resolveFFIType: 'unsigned char') equals: #uchar.
	self assert: (CigType resolveFFIType: 'void*') equals: #'void*'.
	self assert: (CigType resolveFFIType: 'char*') equals: #'char*'.
	self assert: (CigType resolveFFIType: 'unsigned*') equals: #'uint*'.
	self assert: (CigType resolveFFIType: 'unsigned long**') equals: #'ulong**'.
	self assert: (CigType resolveFFIType: 'uint64_t*') equals: #'uint64_t*'
]

{ #category : 'tests' }
CigTypeTest >> testResolveTypeForClassCanAnswerElementClass [
	| element type |
	
	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'GradientPoint'. 'color' }.
	
	type := element resolveType.
	
	self 
		assert: type element
		equals: (self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'Color' })
]

{ #category : 'tests' }
CigTypeTest >> testResolveTypeInNamespace [ 
	| path |

	path := CigType toTypePath: 'FColorPalette::FSetPalette'.
	self assert: path equals: #('FColorPalette' 'FSetPalette')
]
