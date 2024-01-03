Class {
	#name : 'CigCTemplateCollectorTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
CigCTemplateCollectorTest >> testCollectionOfType [
	| collectedTypes |

	collectedTypes := CigTypeSpecializationCollector new 
		typeName: 'TSpan';
		visit: self translatedUnitTvision;
		collected.
		
	self assert: collectedTypes notNil.
	self assert: collectedTypes notEmpty.
	
	self assertCollection: collectedTypes hasSameElements: #(char TScreenCell uint32_t)
]
