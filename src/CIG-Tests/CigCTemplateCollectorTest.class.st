Class {
	#name : 'CigCTemplateCollectorTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
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
