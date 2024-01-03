Extension { #name : 'IGPharoVisitorOld' }

{ #category : '*CIG-Tests' }
IGPharoVisitorOld >> prepareForTest [
	
	types := Dictionary new.
	file := IGHeaderGenerator new
		prefix: 'XX';
		yourself
]
