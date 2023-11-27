Class {
	#name : 'IGTypeTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG',
	#tag : 'Tests'
}

{ #category : 'tests' }
IGTypeTest >> testResolveParamTypeForSimpleType [
	| element type |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'GetSourceModule(int)' }.
	
	type := element parameters first resolveType.
	
	self assert: type cDeclaration equals: 'int'
]

{ #category : 'tests' }
IGTypeTest >> testResolveReturnTypeForClass [
	| element type |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'GetSourceModule(int)' }.
	
	type := element resolveReturnType.
	
	self assert: type cDeclaration equals: 'noise_module_Module*'
]

{ #category : 'tests' }
IGTypeTest >> testResolveReturnTypeForSimpleType [
	| element type |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'GetSourceModuleCount()' }.
	
	type := element resolveReturnType.
	
	self assert: type cDeclaration equals: 'int'
]

{ #category : 'tests' }
IGTypeTest >> testResolveReturnTypeForStructure [
	| element type |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Curve'. 'GetControlPointArray()' }.
	
	type := element resolveReturnType.
	
	self assert: type cDeclaration equals: 'noise_module_ControlPoint*'
]
