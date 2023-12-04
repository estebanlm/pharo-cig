Class {
	#name : 'IGPharoVisitorTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'tests' }
IGPharoVisitorTest >> testVisitTypedefWithCallback [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'utils'. 'NoiseMapCallback' }.
	
	visitor := IGPharoVisitor newForTest.
	visitor visitTypedef: element.
	
	self 
		assert: visitor types keys first
		equals: 'noise_utils_NoiseMapCallback'.
		
	self 
		assert: visitor types values first
		equals: 'FFICallback'
]

{ #category : 'tests' }
IGPharoVisitorTest >> testVisitTypedefWithUint [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'uint' }.
	
	visitor := IGPharoVisitor newForTest.
	visitor visitTypedef: element.
	
	self 
		assert: visitor types keys first
		equals: 'noise_uint'.
		
	self 
		assert: visitor types values first
		equals: '#uint'
]
