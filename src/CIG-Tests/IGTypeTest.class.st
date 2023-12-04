Class {
	#name : 'IGTypeTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'tests' }
IGTypeTest >> testResolveParamTypeForSimpleType [
	| element type |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'GetSourceModule(int)' }.
	
	type := element parameters first resolveType.
	
	self assert: type cDeclaration equals: 'int'
]

{ #category : 'tests' }
IGTypeTest >> testResolveParamWhenTypeIsToStdString [
	| element type |
	
	element := self elementAtPath: { 'noise'. 'utils'. 'WriterBMP'. 'SetDestFilename(const std::string &)'. 'filename'}.
	
	type := element resolveType.
	
	self assert: type cDeclaration equals: 'char*'
]

{ #category : 'tests' }
IGTypeTest >> testResolveParamWhenTypedefToSimpleType [
	| element type |
	
	element := self elementAtPath: { 'noise'. 'utils'. 'Color'. 'Color(noise::uint8, noise::uint8, noise::uint8, noise::uint8)'. 'r'}.
	
	type := element resolveType.
	
	self assert: type cDeclaration equals: 'noise_uint8'
	
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

{ #category : 'tests' }
IGTypeTest >> testResolveTypeForClassCanAnswerElementClass [
	| element type |
	
	element := self elementAtPath: { 'noise'. 'utils'. 'GradientPoint'. 'color' }.
	
	type := element resolveType.
	
	self 
		assert: type element
		equals: (self elementAtPath: { 'noise'. 'utils'. 'Color' })
]

{ #category : 'tests' }
IGTypeTest >> testResolveTypeForClassInStructure [
	| element type |
	
	element := self elementAtPath: { 'noise'. 'utils'. 'GradientPoint'. 'color' }.
	
	type := element resolveType.
	
	self assert: type cDeclaration equals: 'noise_utils_Color*'
]
