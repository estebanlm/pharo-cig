Class {
	#name : 'IGTypeTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'tests' }
IGTypeTest >> testReplaceTypeClassTemplateTypeIn [
	| element result |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.

	result := IGType 
		replaceTypeClassTemplate: element
		type: 'char'
		in: 'TSpan<T> *'.
	self assert: result equals: 'TSpan<char>*'.
	
	result := IGType 
		replaceTypeClassTemplate: element
		type: 'char'
		in: 'TSpan<T>'.
	self assert: result equals: 'TSpan<char>'.

	result := IGType 
		replaceTypeClassTemplate: element
		type: 'char'
		in: 'TSpan<T>*'.
	self assert: result equals: 'TSpan<char>*'
]

{ #category : 'tests' }
IGTypeTest >> testReplaceTypeTemplateTypeIn [
	| element result |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.

	result := IGType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T *'.
	self assert: result equals: 'char*'.
	
	result := IGType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T'.
	self assert: result equals: 'char'.
	
	result := IGType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T*'.
	self assert: result equals: 'char*'.
	
	result := IGType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T &'.
	self assert: result equals: 'char&'.
	
	result := IGType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T&'.
	self assert: result equals: 'char&'.
	
	result := IGType 
		replaceTypeTemplate: element
		type: 'char'
		in: 'T *&'.
	self assert: result equals: 'char*&'
]

{ #category : 'tests' }
IGTypeTest >> testResolveTypeForClassCanAnswerElementClass [
	| element type |
	
	element := self elementAtPath: { 'noise'. 'utils'. 'GradientPoint'. 'color' }.
	
	type := element resolveType.
	
	self 
		assert: type element
		equals: (self elementAtPath: { 'noise'. 'utils'. 'Color' })
]
