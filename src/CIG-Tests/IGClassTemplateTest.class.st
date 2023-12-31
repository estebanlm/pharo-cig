Class {
	#name : 'IGClassTemplateTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'tests' }
IGClassTemplateTest >> testBaseClass [
	| element baseClass methods |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	baseClass := element asBaseClass.
	
	self assert: baseClass name equals: 'TSpan'.
	
	methods := baseClass classMembers reject: [ :each | each isOperator ].
	self denyEmpty: methods.
	self 
		assertCollection: (methods collect: #name) 
		hasSameElements: #('TSpan<T>()' 'TSpan<T>(decltype(nullptr))' 'size()' 'size_bytes()' 'empty()')
]

{ #category : 'tests' }
IGClassTemplateTest >> testSubclassWithSpecializedType [
	| element subclass methods |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	subclass := element asSubclassWithSpecializedType: 'char'.
	
	self assert: subclass name equals: 'TSpanChar'.
	
	methods := subclass classMembers reject: [ :each | each isOperator ].
	self denyEmpty: methods.
	self 
		assertCollection: (methods collect: #name) 
		hasSameElements: #('TSpan<T>(T *, int)' 'data()' 'front()' 'back()' 'subspan(int)' 'subspan(int, int)' 'begin()' 'cbegin()' 'end()' 'cend()')
]
