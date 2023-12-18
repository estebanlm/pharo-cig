Class {
	#name : 'BaselineOfCIG',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfCIG',
	#package : 'BaselineOfCIG'
}

{ #category : 'baselines' }
BaselineOfCIG >> baseline: spec [
	<baseline>
	
	spec for: #common do: [ 
		spec 
			package: 'CIG-LibClang';
			package: 'CIG' with: [ spec requires: 'CIG-LibClang' ];
			package: 'CIG-Tests' with: [ spec requires: 'CIG' ] ]
]
