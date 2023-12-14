Class {
	#name : 'IGParameterTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'tests' }
IGParameterTest >> testParameterCallbackCastsCorrectly [
	| element |
			
	element := self translatedUnitTvision elementAtPath: { 'TGroup' . 'forEach(void (*)(TView *, void *), void *)' . 'func' }.
	
	self 
		assert: element resolveType cDeclaration
		equals: 'void*'
]
