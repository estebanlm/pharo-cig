Extension { #name : 'IGPharoVisitor' }

{ #category : '*CIG-Tests' }
IGPharoVisitor >> prepareForTest [
	
	types := Dictionary new.
	file := IGHeaderGenerator new
		prefix: 'XX';
		yourself
]
