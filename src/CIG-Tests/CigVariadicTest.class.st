Class {
	#name : 'CigVariadicTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigVariadicTest >> testCreateVariadic [ 
	| element |
	
	element := CigVariadic
		newDeclaration: 'int somefunction(long arg0, char *arg1, SomeObject **arg2)'
		selector: #someFunction:object:.
		
	self
		assert: element name 
		equals: 'somefunction(long, char*, SomeObject**)'.
		
	self 
		assert: element cDeclaration 
		equals: 'int somefunction(long arg0, char *arg1, SomeObject **arg2)'
]

{ #category : 'tests' }
CigVariadicTest >> testParseDeclarationParseCorrectlyArgumentNames [
	| variadic |
	
	variadic := CigVariadic 
		newDeclaration: #(void function(int a, char *b)) 
		selector: #a:b:.
		
	self 
		assert: (variadic parsedFunction arguments first) name 
		equals: 'a'.
		
	self 
		assert: (variadic parsedFunction arguments second) name 
		equals: 'b'.		
]
