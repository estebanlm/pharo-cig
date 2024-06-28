Class {
	#name : 'CigTypeDisambiguatorTest',
	#superclass : 'TestCase',
	#category : 'CIG-Tests-Misc',
	#package : 'CIG-Tests',
	#tag : 'Misc'
}

{ #category : 'private' }
CigTypeDisambiguatorTest >> disambiguator [

	^ CigTypeDisambiguator uniqueInstance
]

{ #category : 'tests' }
CigTypeDisambiguatorTest >> testCopyStringUntilSeparatorAnySeparator [

	Character separators do: [ :each |
		self 
			assert: (self disambiguator copyStringUntilSeparator: 'std::vector<GObject>', each asString, 'function(int)')
			equals: 'std::vector<GObject>' ]
]

{ #category : 'tests' }
CigTypeDisambiguatorTest >> testDisambiguateParameterStdVectorInt [

	^ self 
		assert: (self disambiguator 
			disambiguateIntIn: 'int arg' 
			with: 'std::vector<int> arg')
		equals: 'std::vector<int> arg'
]

{ #category : 'tests' }
CigTypeDisambiguatorTest >> testDisambiguateReturnIntNoDisambiguate [

	^ self 
		assert: (self disambiguator 
			disambiguateIntIn: 'int' 
			with: 'int function(int)')
		equals: 'int'
]

{ #category : 'tests' }
CigTypeDisambiguatorTest >> testDisambiguateReturnSizeT [

	^ self 
		assert: (self disambiguator 
			disambiguateIntIn: 'int' 
			with: 'size_t function(int)')
		equals: 'size_t'
]

{ #category : 'tests' }
CigTypeDisambiguatorTest >> testDisambiguateReturnStdVectorInt [

	^ self 
		assert: (self disambiguator 
			disambiguateIntIn: 'int' 
			with: 'std::vector<int> function(int)')
		equals: 'std::vector<int>'
]

{ #category : 'tests' }
CigTypeDisambiguatorTest >> testDisambiguateReturnStdVectorIntPointer [

	^ self 
		assert: (self disambiguator 
			disambiguateIntIn: 'int' 
			with: 'std::vector<int*> function(int)')
		equals: 'std::vector<int*>'
]

{ #category : 'tests' }
CigTypeDisambiguatorTest >> testDisambiguateReturnStdVectorIntPointerPointer [

	Character separators do: [ :each |
		self 
			assert: (self disambiguator 
				disambiguateIntIn: 'int' 
				with: 'std::vector<int*>*', each asString, 'function(int)')
			equals: 'std::vector<int*>*' ]
]
