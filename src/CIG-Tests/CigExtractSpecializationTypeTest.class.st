Class {
	#name : 'CigExtractSpecializationTypeTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests-Misc',
	#package : 'CIG-Tests',
	#tag : 'Misc'
}

{ #category : 'tests' }
CigExtractSpecializationTypeTest >> testExtractSimpleSpecializationType [ 

	self 
		assert: (CigFunctionParser parse: 'TSpan<TScreenCell>') templates
		equals: #('TScreenCell')
]

{ #category : 'tests' }
CigExtractSpecializationTypeTest >> testExtractSpecializationTypesWithComplexDeclaration [
	| types |

	types := CigFunction new extractSpecializationTypesOf: 'std::enable_if_t<!std::is_member_function_pointer<T>::value && !std::is_function<std::remove_pointer_t<T>>::value && !std::is_function<T>::value && std::is_pointer<T>::value && std::is_object<T>::value && !std::is_class<T>::value, std::nullptr_t>'.
	self 
		assert: types
		equals: #('std::is_member_function_pointer<T>::value&&!std::is_function<std::remove_pointer_t<T>>::value&&!std::is_function<T>::value&&std::is_pointer<T>::value&&std::is_object<T>::value&&!std::is_class<T>::value' 'std::nullptr_t')
]

{ #category : 'tests' }
CigExtractSpecializationTypeTest >> testExtractSpecializationTypesWithConstQualifier [
	| types |

	types := CigFunction new extractSpecializationTypesOf: 'const volatile __tuple_element_t<__i, _Tp>'.
	self assert: types equals: #('__i' '_Tp')
]

{ #category : 'tests' }
CigExtractSpecializationTypeTest >> testExtractSpecializationTypesWithConstant [
	| types |

	types := CigFunction new extractSpecializationTypesOf: 'std::array<abc,42>'.
	self assert: types equals: #('abc' '42')
]

{ #category : 'tests' }
CigExtractSpecializationTypeTest >> testExtractSpecializationTypesWithNestedTemplateTypeAndConstant [
	| types |

	types := CigFunction new extractSpecializationTypesOf: 'std::array<std::array<wchar,2>,256>'.
	self assert: types equals: #('std::array<wchar,2>' '256')
]
