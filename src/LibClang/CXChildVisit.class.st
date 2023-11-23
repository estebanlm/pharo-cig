Class {
	#name : 'CXChildVisit',
	#superclass : 'SharedPool',
	#classVars : [
		'CXChildVisit_Break',
		'CXChildVisit_Continue',
		'CXChildVisit_Recurse'
	],
	#category : 'LibClang',
	#package : 'LibClang'
}

{ #category : 'accessing' }
CXChildVisit class >> break [

	^ CXChildVisit_Break
]

{ #category : 'accessing' }
CXChildVisit class >> continue [

	^ CXChildVisit_Continue
]

{ #category : 'class initialization' }
CXChildVisit class >> initialize [

	CXChildVisit_Break := 0.
	CXChildVisit_Continue := 1.
	CXChildVisit_Recurse := 2
]

{ #category : 'accessing' }
CXChildVisit class >> recurse [

	^ CXChildVisit_Recurse
]
