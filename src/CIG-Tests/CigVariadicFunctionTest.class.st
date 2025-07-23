Class {
	#name : 'CigVariadicFunctionTest',
	#superclass : 'CigPharoBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'tests' }
CigVariadicFunctionTest >> testGenerateVariadicFunction [ 
	| unit element template |
	
	unit := CigCLibraryGenerator new 
		packageName: 'Unit';
		prefix: 'Unit';
		importUnit: '/* Nothing, I just want the variadics */';
		declareVariadic: 'int printf(char *fmt, char *value)' as: #printf:string:;
		declareVariadic: 'int printf(char *fmt, long value)' as: #printf:long:;
		translateUnit.

	element := unit elements first.
	template := element phTemplate.

	self 
		assert: template generate
		equals: 'printf: fmt string: value

	self ffiCall: #(int printf(char *fmt, char *value))'.

	element := unit elements second.
	template := element phTemplate.	
	self 
		assert: template generate
		equals: 'printf: fmt long: value

	self ffiCall: #(int printf(char *fmt, long value))'	
]

{ #category : 'tests' }
CigVariadicFunctionTest >> testVariadicFunctionIsAddedToElementList [
	| unit |
	
	unit := CigCLibraryGenerator new 
		packageName: 'Unit';
		prefix: 'Unit';
		importUnit: '/* Nothing, I just want the variadics */';
		declareVariadic: 'int printf(char *fmt, char *value)' as: #printf:string:;
		declareVariadic: 'int printf(char *fmt, long value)' as: #printf:long:;
		translateUnit.

	self assert: unit elements size equals: 2
]
