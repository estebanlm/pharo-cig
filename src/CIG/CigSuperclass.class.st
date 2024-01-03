Class {
	#name : 'CigSuperclass',
	#superclass : 'CigElement',
	#instVars : [
		'typePath'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
CigSuperclass class >> kind [
	
	^ CXCursor_CXXBaseSpecifier
]

{ #category : 'visiting' }
CigSuperclass >> accept: aVisitor [
	"is used by its parent"
]

{ #category : 'initialization' }
CigSuperclass >> fromCursor: aCursor [
	| declaration |

	super fromCursor: aCursor.
	declaration := aCursor type typeDeclaration.
	typePath := declaration withAllParents allButFirst collect: [ :each | each spelling ]
]

{ #category : 'testing' }
CigSuperclass >> isSuperclass [

	^ true
]

{ #category : 'accessing' }
CigSuperclass >> name [

	^ typePath last
]

{ #category : 'accessing' }
CigSuperclass >> reference [
	
	^ self root elementAtPath: self typePath
]

{ #category : 'accessing' }
CigSuperclass >> typePath [

	^ typePath
]
