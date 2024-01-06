Class {
	#name : 'CigPharoTypedefGenerator',
	#superclass : 'CigPharoGenerator',
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'instance creation' }
CigPharoTypedefGenerator class >> newFile: aLibraryGenerator typedef: aTypedef [ 
	
	^ self new
		file: aLibraryGenerator;
		unit: aTypedef root;
		typedef: aTypedef;
		yourself
	
]

{ #category : 'generating' }
CigPharoTypedefGenerator >> generate [
	"in fact, typedef just has to register to be added after"
]

{ #category : 'generating' }
CigPharoTypedefGenerator >> generateOn: aVisitor [
	"in fact, typedef just has to register to be added after"
	
	super generateOn: aVisitor.
	aVisitor 
		registerDeclaration: self element cDeclaration 
		as: self element phTemplate generate
]
