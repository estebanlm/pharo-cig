Class {
	#name : 'CigCVisitor',
	#superclass : 'CigCBaseVisitor',
	#instVars : [
		'fileReference',
		'stack',
		'cStream',
		'hStream'
	],
	#category : 'CIG-C',
	#package : 'CIG',
	#tag : 'C'
}

{ #category : 'private - rendering' }
CigCVisitor >> addCHeaders [
		
	cStream << '#include "' << (self fileReference withExtension: 'h') basename << '"' << String cr.
	cStream cr
]

{ #category : 'private - rendering' }
CigCVisitor >> addCPreamble [
		
	cStream << 'extern "C" {

'
]

{ #category : 'private - rendering' }
CigCVisitor >> addHHeaders [
	| def |
		
	def := self fileReference basenameWithoutExtension asUppercase.
	hStream << '#ifndef ' << def  << String cr.
	hStream << '#define ' << def  << String cr.
	(self file namespaces 
		collect: [ :each | each cppHeader ]
		as: Set)
		do: [ :each |
			hStream cr.
			hStream << '#include "' << each << '"' ].
	hStream cr
]

{ #category : 'private - rendering' }
CigCVisitor >> addHPreamble [
		
	hStream << 'extern "C" {

'
]

{ #category : 'accessing' }
CigCVisitor >> cStream [

	^ cStream
]

{ #category : 'private - rendering' }
CigCVisitor >> endCPreamble [
		
	cStream << '}
'
]

{ #category : 'private - rendering' }
CigCVisitor >> endHFile [
	| def |
		
	def := self fileReference basenameWithoutExtension asUppercase.
	hStream << '
}
	
#endif /* ' << def << '*/'.
]

{ #category : 'accessing' }
CigCVisitor >> fileReference [
	
	^ fileReference ifNil: [ fileReference := self file cFileReference ]
]

{ #category : 'accessing' }
CigCVisitor >> hStream [

	^ hStream
]

{ #category : 'private' }
CigCVisitor >> indentDo: aBlock [

	aBlock value
]

{ #category : 'initialization' }
CigCVisitor >> initialize [

	super initialize.
	stack := Stack new
]

{ #category : 'private - factory' }
CigCVisitor >> newCStream [

	^ self newStreamFor: self fileReference ensureDelete
]

{ #category : 'private - factory' }
CigCVisitor >> newHStream [

	^ self newStreamFor: (self fileReference withExtension: 'h') ensureDelete
]

{ #category : 'private - factory' }
CigCVisitor >> newHeaderVisitor [

	^ CigCHeaderDeclareVisitor new 
		file: self file;
		hStream: self hStream; 
		yourself
]

{ #category : 'private - factory' }
CigCVisitor >> newStreamFor: aFileReference [

	^ ZnNewLineWriterStream on: aFileReference writeStream
]

{ #category : 'private' }
CigCVisitor >> pop [ 
	
	^ stack pop
]

{ #category : 'private' }
CigCVisitor >> prefix [

	^ String streamContents: [ :s |
		(stack reversed collect: #name as: Array) 
			asStringOn: s delimiter: '_' ]
]

{ #category : 'private' }
CigCVisitor >> push: anObject [

	stack push: anObject
]

{ #category : 'visiting' }
CigCVisitor >> visitClass: aClass [

	self push: aClass.
	[  
		self indentDo: [  
			self hStream << '/* BEGIN CLASS: ' << aClass name << ' */' << String cr.
			self cStream << '/* BEGIN CLASS: ' << aClass name << ' */' << String cr.
			super visitClass: aClass. 
			"we do not generate dispose if operator new is overloaded, because the free of the 
			 memory will be handled differently (by hand)"
			aClass shouldExposeDispose ifTrue: [
				self hStream << aClass cDisposeTemplate generateHeader << ';'; cr.
				self cStream << aClass cDisposeTemplate generate; cr ].
			self hStream << '/* END CLASS: ' << aClass name << ' */' << String cr << String cr.
			self cStream << '/* END CLASS: ' << aClass name << ' */' << String cr << String cr ] ]
	ensure: [
		self pop ]
]

{ #category : 'visiting' }
CigCVisitor >> visitClassTemplate: aClassTemplate [

	"we add one subclass for each specialized type"
	aClassTemplate typeSpecializations do: [ :each |
		self visitClass: (aClassTemplate addSubclassWithSpecializedType: each) ]
]

{ #category : 'visiting' }
CigCVisitor >> visitConstructor: aConstructor [

	aConstructor canBeExported ifFalse: [ ^ self ].
	
	self hStream << aConstructor cTemplate generateHeader << ';'; cr.
	self cStream << aConstructor cTemplate generate; cr
]

{ #category : 'visiting' }
CigCVisitor >> visitDestructor: aDestructor [

	"no destructor generation (no point)"
]

{ #category : 'visiting' }
CigCVisitor >> visitEnum: anEnum [

	"this is generated in the header declaration."
]

{ #category : 'visiting' }
CigCVisitor >> visitFunction: aFunction [

	aFunction canBeExported ifFalse: [ ^ self ].
	
	self hStream << aFunction cTemplate generateHeader << ';'; cr.
	self cStream << aFunction cTemplate generate; cr
]

{ #category : 'visiting' }
CigCVisitor >> visitMethod: aMethod [

	self visitFunction: aMethod
]

{ #category : 'visiting' }
CigCVisitor >> visitNamespace: aNamespace [

	(self includesNamespace: aNamespace cppDeclaration) ifTrue: [
		"skip the namespace since is already there, but try to process nested namespaces"
		self visitAll: (aNamespace elements select: [ :each | each isNamespace ]). 
		 ^ self ].

	self push: aNamespace.
	[ 
		self indentDo: [  
			cStream << '/* BEGIN NAMESPACE: ' << aNamespace name << ' */' << String cr << String cr.
			super visitNamespace: aNamespace.
			cStream << '/* END NAMESPACE: ' << aNamespace name << ' */' << String cr << String cr ] ]
	ensure: [ 
		self pop ]
]

{ #category : 'visiting' }
CigCVisitor >> visitStructure: aStructure [

	aStructure canBeExported ifFalse: [ ^ self ].
	"act as class if it behaves as a class"
	self flag: #TODO. "Maybe add accessors for fields? (style properties)"
	aStructure isClass
		ifTrue: [ ^ self visitClass: aStructure ].
		
	self hStream << aStructure cTemplate generate; cr
]

{ #category : 'visiting' }
CigCVisitor >> visitUnit: aUnit [
	| headerVisitor |

	root := aUnit.
	
	cStream := self newCStream.
	hStream := self newHStream.	
	[		
		headerVisitor := self newHeaderVisitor.	
		self addHHeaders.		
		headerVisitor visitDefinesBeforeHeader: aUnit.
		hStream cr.
		hStream << '#include <' << self file fileReference basename << '>'.
		hStream cr; cr.
		self addHPreamble.
		hStream << '/* BEGIN SECTION: DECLARATIONS */' << String cr.
		headerVisitor visit: aUnit.
		hStream << '/* END SECTION: DECLARATIONS */' << String cr << String cr.
		self addCHeaders.
		self addCPreamble.
		self visitAll: aUnit elements.
		self endCPreamble.
		self endHFile ]
	ensure: [ 
		hStream close.
		cStream close ]
]
