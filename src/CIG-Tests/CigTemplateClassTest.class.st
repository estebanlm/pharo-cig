Class {
	#name : 'CigTemplateClassTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigTemplateClassTest >> testTemplateClass [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	self assert: element isClassTemplate.
	
	element := self translatedUnitTvision elementAtPath: { 'TScreenCell' }.
	self deny: element isClassTemplate
]

{ #category : 'tests' }
CigTemplateClassTest >> testTemplateClassHasTemplateTypeParameter [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	self denyEmpty: element templateTypeParameters
]

{ #category : 'tests' }
CigTemplateClassTest >> testTemplateClassWithoutConstructorAddsOneDefault [
	| element specialized |

	element := self translatedUnitStdArray elementAtPath: { 'std'. 'array' }.
	
	self assertEmpty: element constructors.
	specialized := element addSubclassWithSpecializedType: #DoesntMatter.
	self denyEmpty: specialized constructors.
	self assert: specialized constructors size equals: 1
]
