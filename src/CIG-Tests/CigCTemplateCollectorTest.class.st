Class {
	#name : 'CigCTemplateCollectorTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'tests' }
CigCTemplateCollectorTest >> testCollectionOfSpecializedType [
	"tests a direct specialisation is incorporated as specialisation"
	| unit collectedTypes |

	unit := CigCppLibraryGenerator new
		from: 'array' import: #('std::array');
		cSpecialize: 'std::array<char, 4>';
		withoutSpecialElements;
		translateUnit.
		
	collectedTypes := CigTypeSpecializationCollector new 
		typeName: 'std::array';
		visit: unit;
		collected.

	self assert: collectedTypes notNil.
	self assert: collectedTypes notEmpty.

	self assertCollection: collectedTypes hasSameElements: #( ('char' '4') )
]

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
