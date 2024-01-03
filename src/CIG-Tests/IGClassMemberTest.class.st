Class {
	#name : 'IGClassMemberTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
IGClassMemberTest >> testParameterTypeTemplate [
	| element |

	"this is a template"
	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>'. 'TSpan<T>(T *, int)' }.
	self assert: (element hasAnyParameterTypeTemplateOf: element parent).
	
	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>'. 'TSpan<T>()' }.
	self deny: (element hasAnyParameterTypeTemplateOf: element parent)
]

{ #category : 'tests' }
IGClassMemberTest >> testReturnTypeClassTemplate [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>'. 'subspan(int)' }.
	self assert: (element isReturnTypeClassTemplateOf: element parent)
]

{ #category : 'tests' }
IGClassMemberTest >> testReturnTypeTemplate [
	| element |

	"this is a template"
	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>'. 'data()' }.
	self assert: (element isReturnTypeTemplateOf: element parent).
	
	"this is not a template, even if part of same template class"
	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>'. 'empty()' }.
	self deny: (element isReturnTypeTemplateOf: element parent)
]
