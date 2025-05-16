Class {
	#name : 'BaselineOfCIG',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfCIG',
	#package : 'BaselineOfCIG'
}

{ #category : 'baseline' }
BaselineOfCIG >> baseline: spec [
	<baseline>
	
	spec for: #common do: [
	
		self lightLogger: spec.
	
		spec 
			package: 'CIG-LibClang';
			package: 'CIG' with: [ spec requires: #('CIG-LibClang' 'LightLoader') ];
			package: 'CIG-Tests' with: [ spec requires: #('CIG') ] ]
]

{ #category : 'external projects' }
BaselineOfCIG >> lightLogger: spec [

	spec baseline: 'LightLogger' with: [ 
		spec 
			repository: 'github://pharo-project/beacon';
			loads: #('default') ]
]
