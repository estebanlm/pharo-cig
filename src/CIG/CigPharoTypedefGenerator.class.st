Class {
	#name : 'CigPharoTypedefGenerator',
	#superclass : 'CigPharoGenerator',
	#category : 'CIG-Pharo-Generator',
	#package : 'CIG',
	#tag : 'Pharo-Generator'
}

{ #category : 'generating' }
CigPharoTypedefGenerator >> generate [
	"in fact, typedef just has to register to be added after"
]

{ #category : 'generating' }
CigPharoTypedefGenerator >> generateOn: aVisitor [
	"in fact, typedef just has to register to be added after"
	| declaration template |
	
	declaration := self element cDeclaration.
	template := self element phTemplate generate.
	
	logger trace: declaration. 
	logger trace: template.
	
	super generateOn: aVisitor.
	aVisitor 
		registerDeclaration: declaration 
		as: template
]
