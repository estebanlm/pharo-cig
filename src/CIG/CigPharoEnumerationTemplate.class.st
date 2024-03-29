"
A template to generate enum declarations.
"
Class {
	#name : 'CigPharoEnumerationTemplate',
	#superclass : 'CigPharoTemplate',
	#category : 'CIG-Pharo-Template',
	#package : 'CIG',
	#tag : 'Pharo-Template'
}

{ #category : 'private' }
CigPharoEnumerationTemplate >> anonymousElementName [
	| index |

	index := self indexOfElement.
	^ String streamContents: [ :stream |
		stream << self prefix << index asString ]
]

{ #category : 'private' }
CigPharoEnumerationTemplate >> anonymousTypeName [
	| index |
	
	index := self indexOfElement.
	^ String streamContents: [ :stream |
		stream <<  self element parent phDeclaration.
		stream << self prefix capitalized << index asString ]
]

{ #category : 'accessing' }
CigPharoEnumerationTemplate >> elementName [
	
	^ self element isAnonymous
		ifTrue: [ self anonymousElementName ]
		ifFalse: [ self element name ]
]

{ #category : 'generating' }
CigPharoEnumerationTemplate >> generateEnumDecl [
	"the structure is a field of another structure"
	
	^ String streamContents: [ :stream |
		stream << 'enumDecl'; cr.
		stream cr; tab.
		stream << '^ #('; cr.
		self element elements 
			do: [ :each | 
				stream tab.
				stream << each name << ' ' << each value asString ]
			separatedBy: [ 
				stream cr ].
		stream << ' )' ]
]

{ #category : 'accessing' }
CigPharoEnumerationTemplate >> indexOfElement [
	
	^ self element parent indexOfElementOfSameKind: element
]

{ #category : 'private' }
CigPharoEnumerationTemplate >> prefix [
	
	^ 'enum'
]

{ #category : 'accessing' }
CigPharoEnumerationTemplate >> typeName [

	^ self element isAnonymous
		ifTrue: [ self anonymousTypeName ]
		ifFalse: [ self element phDeclaration ]
]
