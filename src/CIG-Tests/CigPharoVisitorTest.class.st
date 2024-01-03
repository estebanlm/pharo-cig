Class {
	#name : 'CigPharoVisitorTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitMethodDeclaredWithoutArgumentNamesGeneratesDefaultNames [
	| element |

	element := self translatedUnitTvision elementAtPath: { 'TEditor'. 'insertBuffer(const char *, uint, uint, Boolean, Boolean)' }.
	
	self 
		assert: element phDeclaration 
		equals: 'insertBufferArg1: arg1 arg2: arg2 arg3: arg3 arg4: arg4 arg5: arg5'
]

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitTypedefWithCallback [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'utils'. 'NoiseMapCallback' }.
	
	visitor := CigPharoVisitor newForTest.
	visitor visitTypedef: element.
	
	self 
		assert: visitor types keys first
		equals: 'nu_noise_utils_NoiseMapCallback'.
		
	self 
		assert: visitor types values first
		equals: 'FFICallback'
]

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitTypedefWithUint [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'uint' }.
	
	visitor := CigPharoVisitor newForTest.
	visitor visitTypedef: element.
	
	self 
		assert: visitor types keys first
		equals: 'no_noise_uint'.
		
	self 
		assert: visitor types values first
		equals: '#uint'
]
