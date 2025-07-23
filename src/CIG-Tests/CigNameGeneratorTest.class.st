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

{ #category : 'utils' }
CigNameGeneratorTest >> newUnit: aString [

	^ CigCLibraryGenerator new 
		packageName: 'Unit';
		prefix: 'Unit';
		importUnit: aString;
		translateUnit
]

{ #category : 'tests' }
CigNameGeneratorTest >> testDoesNotClashesWithAndWithoutPrefix [
	| unit st1 st2 st3 |

	unit := self newUnit: '
		struct abc { int a; };
		struct UnitAbc { int b; };
		struct other { int c; };'.
	st1 := unit elements first.
	st2 := unit elements second. 
	st3 := unit elements third. 

	self assert: (self nameGenerator visitElement: st1) equals: 'Abc'.
	self assert: (self nameGenerator visitElement: st2) equals: 'UnitAbc'.
	"this is to control that the prefix is done anyway"
	self assert: (self nameGenerator visitElement: st3) equals: 'UnitOther'.
]

{ #category : 'tests' }
CigNameGeneratorTest >> testDoesNotClashesWithAndWithoutPrefixAndUnderscore [
	| unit st1 st2 st3 st4 |

	unit := self newUnit: '
		struct abc { int a; };
		struct Unit_abc { int b; };
		struct abc2 { int a; };
		struct unit_abc2 { int b; };'.
	
	st1 := unit elements first.
	st2 := unit elements second. 
	st3 := unit elements third.
	st4 := unit elements fourth.
	
	self assert: (self nameGenerator visitElement: st1) equals: 'Abc'.
	self assert: (self nameGenerator visitElement: st2) equals: 'UnitAbc'.
	self assert: (self nameGenerator visitElement: st3) equals: 'Abc2'.
	self assert: (self nameGenerator visitElement: st4) equals: 'UnitAbc2'	
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
