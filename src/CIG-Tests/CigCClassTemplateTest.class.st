Class {
	#name : 'CigCClassTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
CigCClassTemplateTest >> testGenerateHeader [
	| element template |

	element := self translatedUnitTvision elementAtPath: { 'TObject' }.
	template := CigCClassTemplate for: element.
	
	self 
		assert: template generateHeader
		equals: 'typedef void tv_TObject;'
]

{ #category : 'tests' }
CigCClassTemplateTest >> testGeneratedConstructorsGeneratesCorrrectMethod [
	| element specialized template |

	element := self translatedUnitStdArray elementAtPath: { 'std'. 'array' }.
	specialized := element addSubclassWithSpecializedTypes: #('char' '4').
	template := CigCMethodTemplate for: specialized constructors first.
	
	self 
		assert: template generateHeader
		equals: 'xx_std_arrayChar4* xx_std_arrayChar4_new()'.
		
	self 
		assert: template generateBody 
		equals: 'return (xx_std_arrayChar4*)(new std::array<char, 4>());'
]
