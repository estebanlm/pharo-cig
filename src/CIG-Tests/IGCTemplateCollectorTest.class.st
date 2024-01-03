Class {
	#name : 'IGCTemplateCollectorTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests' }
IGCTemplateCollectorTest >> testCollectionOfType [
	| collectedTypes |

	collectedTypes := IGTypeSpecializationCollector new 
		typeName: 'TSpan';
		visit: self translatedUnitTvision;
		collected.
		
	self assert: collectedTypes notNil.
	self assert: collectedTypes notEmpty.
	
	self assertCollection: collectedTypes hasSameElements: #(char TScreenCell uint32_t)
]
