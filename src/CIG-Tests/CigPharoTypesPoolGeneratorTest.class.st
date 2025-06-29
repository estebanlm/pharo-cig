Class {
	#name : 'CigPharoTypesPoolGeneratorTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'tests' }
CigPharoTypesPoolGeneratorTest >> testValueForUnsignedCharArray [
	| value |

	value := CigPharoTypesPoolGenerator new 
		valueFor: 'unsigned char[1024]' 
		in: Dictionary new.

	self assert: value equals: 'FFIArray ofType: ''uchar'' size: 1024'
]
