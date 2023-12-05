Class {
	#name : 'IGStructure',
	#superclass : 'IGElement',
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGStructure class >> kind [
	
	^ CXCursor_StructDecl
]

{ #category : 'visiting' }
IGStructure >> accept: aVisitor [

	aVisitor visitStructure: self
]

{ #category : 'accessing' }
IGStructure >> fields [
	
	^ self elements select: [ :each | each isField ]
]

{ #category : 'testing' }
IGStructure >> isAbstract [

	^ self methods anySatisfy: [ :each | each isPureVirtual ]
]

{ #category : 'testing' }
IGStructure >> isClass [

	^ self methods notEmpty
]

{ #category : 'accessing' }
IGStructure >> methods [

	^ self elements select: [ :each | each isMethod ]
]
