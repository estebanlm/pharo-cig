Class {
	#name : 'CigCClassTemplateTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
CigCClassTemplateTemplateTest >> testMethodReturningConstTemplate [
	| element subclass method template |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	subclass := element addSubclassWithSpecializedType: 'char'.

	method := subclass elementAtPath: { 'cbegin()' }.
	template := 	method cTemplate.
	
	self 
		assert: template generateBody 
		equals: 'return (const char*)(((TSpan<char>*)self)->cbegin());'
]

{ #category : 'tests' }
CigCClassTemplateTemplateTest >> testMethodReturningTemplateArgument [
	| element subclass method template |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	subclass := element addSubclassWithSpecializedType: 'TScreenCell'.

	method := subclass elementAtPath: { 'subspan(int)' }.
	template := 	method cTemplate.
	
	self 
		assert: template generateBody 
		equals: 'auto _result = new TSpan<TScreenCell>();
*_result = ((TSpan<TScreenCell>*)self)->subspan(pos);
return (tv_TSpanTScreenCell*)_result;'
]

{ #category : 'tests' }
CigCClassTemplateTemplateTest >> testMethodReturningTemplateArgumentWithPointer [
	| element subclass method template |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	subclass := element addSubclassWithSpecializedType: 'TScreenCell'.

	method := subclass elementAtPath: { 'data()' }.
	template := 	method cTemplate.
	
	self 
		assert: template generateBody 
		equals: 'return (tv_TScreenCell*)(((TSpan<TScreenCell>*)self)->data());'
]

{ #category : 'tests' }
CigCClassTemplateTemplateTest >> testMethodReturningTemplateArgumentWithSpecialNewGenerateAnExtraArgument [
	| element subclass method template |

	self skip. "I do not find a correct example of this :("

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	subclass := element addSubclassWithSpecializedType: 'TScreenCell'.

	method := subclass elementAtPath: { 'data()' }.
	template := 	method cTemplate.
	
	self 
		assert: template generateHeader 
		equals: 'void tv_TSpanTScreenCell_data(tv_TSpanTScreenCell* self, tv_TScreenCell* result)'
]

{ #category : 'tests' }
CigCClassTemplateTemplateTest >> testMethodWithTemplateTypeUpdatesAlsoTypeReference [
	| element subclass method |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	
	subclass := element addSubclassWithSpecializedType: 'TScreenCell'.
	method := subclass elementAtPath: { 'data()' }.
	self 
		assert: method typeReference name
		equals: 'struct TScreenCell'.
		
	subclass := element addSubclassWithSpecializedType: 'char'.
	method := subclass elementAtPath: { 'data()' }.
	self 
		assert: method typeReference name
		equals: 'char'
]

{ #category : 'tests' }
CigCClassTemplateTemplateTest >> testSubclassWithSpecializedType [
	| element subclass methods |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	subclass := element addSubclassWithSpecializedType: 'char'.
	
	self assert: subclass name equals: 'TSpanChar'.
	
	methods := subclass classMembers reject: [ :each | each isOperator ].
	self denyEmpty: methods.
	self 
		assertCollection: (methods collect: #name) 
		hasSameElements: #('TSpan<T>()' 'TSpan<T>(T *, int)' 'TSpan<T>(decltype(nullptr))' 'data()' 'size()' 'size_bytes()' 'empty()' 'front()' 'back()' 'subspan(int)' 'subspan(int, int)' 'begin()' 'cbegin()' 'end()' 'cend()')
]

{ #category : 'tests' }
CigCClassTemplateTemplateTest >> testSubclassWithSpecializedTypeCastsCorrectly [
	| element subclass |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	subclass := element addSubclassWithSpecializedType: 'char'.
	
	"test the self cast of this is (TSpan<char>*)self"
	self assert: subclass cppDeclaration equals: 'TSpan<char>'
]