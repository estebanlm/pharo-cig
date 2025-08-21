Class {
	#name : 'CigPharoTypesPoolGeneratorTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'tests' }
CigPharoTypesPoolGeneratorTest >> testValueForMultidimensionalArray [
	| value |

	value := CigPharoTypesPoolGenerator new 
		valueFor: 'unsigned char[10][1024]' 
		in: Dictionary new.

	self assert: value equals: 'FFIArray ofType: ''uchar'' size: 10*1024 requestor: self'
]

{ #category : 'tests' }
CigPharoTypesPoolGeneratorTest >> testValueForTypedefArray [
	| value |

	value := CigPharoTypesPoolGenerator new 
		valueFor: 'ATYPE[42]' 
		in: Dictionary new.

	self assert: value equals: 'FFIArray ofType: ''ATYPE'' size: 42 requestor: self'.
	
	value := CigPharoTypesPoolGenerator new 
		valueFor: 'uchar[8]' 
		in: Dictionary new.

	self assert: value equals: 'FFIArray ofType: ''uchar'' size: 8 requestor: self'
]

{ #category : 'tests' }
CigPharoTypesPoolGeneratorTest >> testValueForUnsignedCharArray [
	| value |

	value := CigPharoTypesPoolGenerator new 
		valueFor: 'unsigned char[1024]' 
		in: Dictionary new.

	self assert: value equals: 'FFIArray ofType: ''uchar'' size: 1024 requestor: self'
]
