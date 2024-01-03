Class {
	#name : 'CigTypeTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
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
CigTypeTest >> testResolveTypeForClassCanAnswerElementClass [
	| element type |
	
	element := self elementAtPath: { 'noise'. 'utils'. 'GradientPoint'. 'color' }.
	
	type := element resolveType.
	
	self 
		assert: type element
		equals: (self elementAtPath: { 'noise'. 'utils'. 'Color' })
]
