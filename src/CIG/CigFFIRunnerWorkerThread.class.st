Class {
	#name : 'CigFFIRunnerWorkerThread',
	#superclass : 'CigFFIRunner',
	#instVars : [
		'workerName'
	],
	#category : 'CIG-Base',
	#package : 'CIG',
	#tag : 'Base'
}

{ #category : 'accessing' }
CigFFIRunnerWorkerThread >> phTemplate [

	^ '(runner ifNil: [ runner := TFWorker named: ''{1}'' ])' format: { self workerName }
]

{ #category : 'accessing' }
CigFFIRunnerWorkerThread >> variablesAddedToFFILibrary [

	^ #(runner)
]

{ #category : 'accessing' }
CigFFIRunnerWorkerThread >> workerName [

	^ workerName
]

{ #category : 'accessing' }
CigFFIRunnerWorkerThread >> workerName: aString [

	workerName := aString
]
