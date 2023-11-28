Class {
	#name : 'IGCVisitorTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'tests' }
IGCVisitorTest >> testArgumentCastAsCPP [
	| element param cast |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Billow'. 'SetNoiseQuality(noise::NoiseQuality)' }.
	
	param := element parameters first.
	
	cast := IGCGenerator new argumentCastToCPP: param.
	
	self assert: cast equals: '(noise::NoiseQuality)noiseQuality' 
]

{ #category : 'tests' }
IGCVisitorTest >> testArgumentCastAsCPPWhenClassInDifferentNamespace [
	| element param cast |
	
	element := self elementAtPath: { 'noise'. 'model'. 'Cylinder'. 'SetModule(const module::Module &)' }.
	
	param := element parameters first.
	
	cast := IGCGenerator new argumentCastToCPP: param.
	
	self assert: cast equals: '*(noise::module::Module*)module' 
]

{ #category : 'tests' }
IGCVisitorTest >> testArgumentCastAsCPPWhenClassReference [
	| element param cast |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'SetSourceModule(int, const Module &)' }.
	
	param := element parameters second.
	
	cast := IGCGenerator new argumentCastToCPP: param.
	
	self assert: cast equals: '*(noise::module::Module*)sourceModule'
]

{ #category : 'tests' }
IGCVisitorTest >> testCCastToReturnWhenClass [
	| element cast |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'GetSourceModule(int)' }.
	
	cast := IGCGenerator new cCastToReturn: element resolveReturnType.
	
	self assert: cast equals: '(noise_module_Module*)&' 
]

{ #category : 'tests' }
IGCVisitorTest >> testCCastToReturnWhenClassInDifferentNamespace [
	| element cast |
	
	element := self elementAtPath: { 'noise'. 'model'. 'Cylinder'. 'GetModule()' }.
	
	cast := IGCGenerator new cCastToReturn: element resolveReturnType.
	
	self assert: cast equals: '(noise_module_Module*)&' 
]

{ #category : 'tests' }
IGCVisitorTest >> testCCastToReturnWhenEnum [
	| element cast |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Billow'. 'GetNoiseQuality()' }.
	
	cast := IGCGenerator new cCastToReturn: element resolveReturnType.
	
	self assert: cast equals: '(noise_NoiseQuality)' 
]
