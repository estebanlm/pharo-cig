Class {
	#name : 'CigLogSignal',
	#superclass : 'BeaconSignal',
	#instVars : [
		'value'
	],
	#category : 'CIG-Logging',
	#package : 'CIG',
	#tag : 'Logging'
}

{ #category : 'instance creation' }
CigLogSignal class >> on: aStringOrBlock [

	^ self new 
		value: aStringOrBlock;
		yourself
]

{ #category : 'printing' }
CigLogSignal >> printOneLineContentsOn: stream [
	
	stream << self value
]

{ #category : 'accessing' }
CigLogSignal >> value [

	^ value value asString
]

{ #category : 'accessing' }
CigLogSignal >> value: aStringOrBlock [

	value := aStringOrBlock
]
