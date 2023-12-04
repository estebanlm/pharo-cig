Class {
	#name : 'IGElementTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'accessing' }
IGElementTest class >> resources [

	^ { IGTestResource }
]

{ #category : 'tests' }
IGElementTest >> testClassCDeclaration [
	| element |

	element := self elementAtPath: { 'noise'. 'module'. 'Module' }.

	self assert: element cDeclaration equals: 'noise_module_Module*'
]

{ #category : 'tests' }
IGElementTest >> testClassCPPDeclaration [
	| element |

	element := self elementAtPath: { 'noise'. 'module'. 'Module' }.

	self assert: element cppDeclaration equals: 'noise::module::Module'
]

{ #category : 'tests' }
IGElementTest >> testStructureCDeclaration [
	| element |

	element := self elementAtPath: { 'noise'. 'module'. 'ControlPoint' }.

	self assert: element cDeclaration equals: 'noise_module_ControlPoint'
]

{ #category : 'tests' }
IGElementTest >> testStructureCPPDeclaration [
	| element |

	element := self elementAtPath: { 'noise'. 'module'. 'ControlPoint' }.
	
	self assert: element cppDeclaration equals: 'noise::module::ControlPoint'
]
