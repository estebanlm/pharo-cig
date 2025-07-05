Class {
	#name : 'CigNameGeneratorTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-Base',
	#package : 'CIG-Tests',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigNameGeneratorTest >> nameGenerator [

	^ CigNameGenerator new
]

{ #category : 'tests' }
CigNameGeneratorTest >> testFunctionNameWithPrefixDoesNotAddsIt [
	| element unit name nameGenerator |

	unit := self translatedUnitIcal.
	unit prefix: 'ical'.
	element := (unit elementAtPath: { 'icaltime_today()' }) copy.

	nameGenerator := self nameGenerator.

	name := nameGenerator visit: element.
	self assert: name equals: 'icaltime_today'.
	
	nameGenerator withoutPrefixInFunctionName.
	name := nameGenerator visit: element.
	self assert: name equals: 'time_today'.
	
	element name: 'ical_time_today'.
	name := nameGenerator visit: element.
	self assert: name equals: 'time_today'	
]

{ #category : 'tests' }
CigNameGeneratorTest >> testRenameStructure [
	| element unit name |

	unit := self translatedUnitIcal.
	unit prefix: 'ical'.
	element := unit elementAtPath: { 'icaltime_span' }.
	
	name := self nameGenerator 
		rename: 'IcaltimeSpan' as: 'IcalTimeSpan';
		visit: element.
	self assert: name equals: 'IcalTimeSpan'
]

{ #category : 'tests' }
CigNameGeneratorTest >> testStructureDoesNotDuplicatePrefix [
	| element unit name |

	unit := self translatedUnitIcal.
	unit prefix: 'ical'.
	element := unit elementAtPath: { 'icaltime_span' }.
	
	name := self nameGenerator visit: element.
	self assert: name equals: 'IcaltimeSpan'
]

{ #category : 'tests' }
CigNameGeneratorTest >> testStructureDoesNotDuplicatePrefixWithUnderscoreSeparator [
	| element unit name nameGenerator |

	unit := self translatedUnitIcal.
	unit prefix: 'ical'.
	element := (unit elementAtPath: { 'icaltime_span' }) copy.
	
	element name: 'ical_time_span'.
	nameGenerator := self nameGenerator withoutCamelCase.
	name := nameGenerator visit: element.
	self assert: name equals: 'Ical_time_span'
]

{ #category : 'tests' }
CigNameGeneratorTest >> testStructureWithUnderscoreSeparatorBecomeCamelCaseIfIndicated [
	| element unit name nameGenerator |

	unit := self translatedUnitIcal.
	unit prefix: 'ical'.
	element := (unit elementAtPath: { 'icaltime_span' }) copy.

	nameGenerator := CigNameGenerator new 
		withCamelCase;
		yourself.

	element name: 'ical_time_span'.
	name := nameGenerator visit: element.
	self assert: name equals: 'IcalTimeSpan'
]
