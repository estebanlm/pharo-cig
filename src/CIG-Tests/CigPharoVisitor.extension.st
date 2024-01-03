Extension { #name : 'CigPharoVisitor' }

{ #category : '*CIG-Tests' }
CigPharoVisitor >> prepareForTest [
	
	types := Dictionary new.
	file := CigLibraryGenerator new
		prefix: 'XX';
		yourself
]
