Class {
	#name : 'CigCFieldTemplateTest',
	#superclass : 'CigCTemplateTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
CigCFieldTemplateTest >> testGenerateStructWithAnonymousFields [
	| template element |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'TCapAttributes' }.
	template := element fields last cTemplate.
	
	self 
		assert: template generate 
		equals: 'fc_uInt8 noname_1'
]

{ #category : 'tests' }
CigCFieldTemplateTest >> testGenerateUnionWhenUnionWasDeclared [
	| template element |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FChar' }.
	template := (element fields detect: [ :each | each name = 'attr' ]) cTemplate.
	
	self 
		assert: template generate 
		equals: 'union fc_finalcut_FAttribute attr'
]
