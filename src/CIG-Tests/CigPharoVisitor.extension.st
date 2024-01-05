Extension { #name : 'CigPharoVisitor' }

{ #category : '*CIG-Tests' }
CigPharoVisitor >> prepareForTest [
	
	types := Dictionary new.
	file := CigLibraryGenerator new
		prefix: 'Gft';
		bindingsName: 'GeneratedForTest';
		yourself
]
