Extension { #name : 'CigPharoVisitorOld' }

{ #category : '*CIG-Tests' }
CigPharoVisitorOld >> prepareForTest [
	
	types := Dictionary new.
	file := CigLibraryGenerator new
		prefix: 'XX';
		yourself
]
