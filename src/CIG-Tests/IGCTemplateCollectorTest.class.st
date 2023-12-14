Class {
	#name : 'IGCTemplateCollectorTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'tests' }
IGCTemplateCollectorTest >> testCollectionOfType [
	| collectedTypes |

	collectedTypes := IGCTemplateCollector new 
		typeName: 'TSpan';
		visit: self translatedUnitTvision;
		collected.
		
	self assert: collectedTypes notNil.
	self assert: collectedTypes notEmpty.
	
	self assertCollection: collectedTypes hasSameElements: #(char TScreenCell)
]
