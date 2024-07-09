Trait {
	#name : 'CigTLoggeable',
	#category : 'CIG-Logging',
	#package : 'CIG',
	#tag : 'Logging'
}

{ #category : 'accessing - logging' }
CigTLoggeable >> logDebug: aStringOrBlock [

	(CigLogDebug on: aStringOrBlock) emit
]

{ #category : 'accessing - logging' }
CigTLoggeable >> logInfo: aStringOrBlock [

	(CigLogInfo on: aStringOrBlock) emit
]
