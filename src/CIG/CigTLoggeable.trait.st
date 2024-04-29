Trait {
	#name : 'CigTLoggeable',
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing - logging' }
CigTLoggeable >> logDebug: aStringOrBlock [

	aStringOrBlock value asBeaconSignal emit
]

{ #category : 'accessing - logging' }
CigTLoggeable >> logInfo: aStringOrBlock [

	aStringOrBlock value asBeaconSignal emit
]
