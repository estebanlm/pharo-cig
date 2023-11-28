Class {
	#name : 'IGSuperclass',
	#superclass : 'IGElement',
	#instVars : [
		'typePath'
	],
	#category : 'CIG-Node',
	#package : 'CIG',
	#tag : 'Node'
}

{ #category : 'accessing' }
IGSuperclass class >> kind [
	
	^ CXCursor_CXXBaseSpecifier
]

{ #category : 'visiting' }
IGSuperclass >> accept: aVisitor [
	"is used by its parent"
]

{ #category : 'initialization' }
IGSuperclass >> fromCursor: aCursor [
	| declaration |

	super fromCursor: aCursor.
	declaration := aCursor type typeDeclaration.
	typePath := declaration withAllParents allButFirst collect: [ :each | each spelling ]
]

{ #category : 'testing' }
IGSuperclass >> isSuperclass [

	^ true
]

{ #category : 'accessing' }
IGSuperclass >> name [

	^ typePath last
]

{ #category : 'accessing' }
IGSuperclass >> reference [
	
	^ self root elementAtPath: self typePath
]

{ #category : 'accessing' }
IGSuperclass >> typePath [

	^ typePath
]
