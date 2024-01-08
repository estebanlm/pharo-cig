Class {
	#name : 'CigTypeTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

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
	
	element := self elementAtPath: { 'noise'. 'utils'. 'GradientPoint'. 'color' }.
	
	type := element resolveType.
	
	self 
		assert: type element
		equals: (self elementAtPath: { 'noise'. 'utils'. 'Color' })
]
