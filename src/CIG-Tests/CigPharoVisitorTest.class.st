Class {
	#name : 'CigPharoVisitorTest',
	#superclass : 'CigPharoBaseTest',
	#category : 'CIG-Tests-Pharo',
	#package : 'CIG-Tests',
	#tag : 'Pharo'
}

{ #category : 'private' }
CigPharoVisitorTest >> addClass: aClass visitor: aVisitor [ 
	
	aVisitor ensureBaseObjectClass: aClass root.
	(CigPharoClassGenerator newFile: aVisitor file class: aClass) generate
]

{ #category : 'tests' }
CigPharoVisitorTest >> testAddFFILibrary [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	visitor addFFILibrary: self translatedUnit.
	
	class := self class environment classNamed: 'LibGeneratedForTest'.
	self assert: class notNil.
	self assert: (class methods anySatisfy: [ :each | each selector = #unix64LibraryName ]).
	self assert: (class methods anySatisfy: [ :each | each selector = #win32LibraryName ]).
	self assert: (class methods anySatisfy: [ :each | each selector = #macLibraryName ])
]

{ #category : 'tests' }
CigPharoVisitorTest >> testAddFFITrait [
	| visitor trait |
	
	visitor := CigPharoVisitor newForTest.
	visitor addFFITrait: self translatedUnit.
	
	trait := self class environment classNamed: 'LibTGeneratedForTest'.
	self assert: trait notNil.
	self assert: (trait methods anySatisfy: [ :each | each selector = #ffiLibraryName ]).
	self assert: (trait class methods anySatisfy: [ :each | each selector = #ffiLibraryName ]).

]

{ #category : 'tests' }
CigPharoVisitorTest >> testAddFFITypesClass [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	visitor addFFITypesClass: self translatedUnit.
	
	class := self class environment classNamed: 'NuGeneratedForTestTypedef'.
	self assert: class notNil
]

{ #category : 'tests' }
CigPharoVisitorTest >> testEnsureBaseObjectClass [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitTvision.

	class := self class environment classNamed: 'TvBaseObject'.
	self assert: class isNil.
	
	visitor ensureBaseObjectClass: self translatedUnitTvision.

	class := self class environment classNamed: 'TvBaseObject'.
	self assert: class notNil
]

{ #category : 'tests' }
CigPharoVisitorTest >> testEnsureBaseObjectClassIncludesBaseMethods [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitTvision.

	visitor ensureBaseObjectClass: self translatedUnitTvision.

	class := self class environment classNamed: 'TvBaseObject'.
	self assert: class notNil.
	self assert: (class canUnderstand: #initialize).
	self assert: (class canUnderstand: #finalize).
	self assert: (class canUnderstand: #dispose).
	self assert: (class canUnderstand: #autoRelease)
]

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitClassAddsClassDisposeMethod [
	| visitor class element |
	
	element := self translatedUnitTvision elementAtPath: { 'TView' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitClass: element.
	
	class := self class environment classNamed: 'TvTView'.
	self assert: class notNil.
	self assert: (class methodDict at: #dispose ifAbsent: [ nil ]) notNil.
	self 
		assert: (class >> #dispose) sourceCode 
		equals: 'dispose

	self ffiCall: #(void tv_TView_dispose(tv_TView* self))'
]

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitClassAddsClassToDefaultNamespace [
	| visitor class element |
	
	element := self translatedUnitTvision elementAtPath: { 'TView' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitClass: element.
	
	class := self class environment classNamed: 'TvTView'.
	self assert: class notNil
]

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitClassWithManyConstructorsDisambiguatesName [
	| visitor class element constructors |
	
	element := self translatedUnitTvision elementAtPath: { 'TView' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitClass: element.
	class := (self class environment classNamed: 'TvTView') class.
	constructors := class methodDict keys select: [ :each | each beginsWith: 'tView_' ].
	self assert: constructors size equals: 2
]

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitFunctionAddsFunctionToLibrary [
	| visitor class element |
	
	element := self translatedUnitTvision elementAtPath: { 'fexpand(char *)' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addFFILibrary: self translatedUnit.
	class := self class environment classNamed: 'LibGeneratedForTest'.
	
	visitor visitFunction: element.
	
	self assert: (class canUnderstand: #fexpand:).
	self 
		assert: (class >> #fexpand:) sourceCode 
		equals: 'fexpand: rpath

	self ffiCall: #(void tv_fexpand_1(char* rpath))'
]

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitMethodAddsClassMethodToClassSide [
	| visitor class element |
	
	element := self translatedUnitTvision elementAtPath: { 'TView'. 'enableCommand(ushort)' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	self addClass: element parent visitor: visitor.
	
	visitor visitMethod: element.
	
	class := self class environment classNamed: 'TvTView'.

	self assert: (class class canUnderstand: #enableCommand:).
	self 
		assert: (class class >> #enableCommand:) sourceCode 
		equals: 'enableCommand: command

	self ffiCall: #(void tv_TView_enableCommand(tv_ushort command))'
]

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitMethodAddsConstructorToClassSide [
	| visitor class element |
	
	element := self translatedUnitTvision elementAtPath: { 'TView'. 'TView(const TRect &)' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	self addClass: element parent visitor: visitor.
	
	visitor visitConstructor: element.
	
	class := self class environment classNamed: 'TvTView'.

	self assert: (class class canUnderstand: #newBounds:).
	self 
		assert: (class class >> #newBounds:) sourceCode 
		equals: 'newBounds: bounds

	^ (self tView_new: bounds) initialize'.
	
	self assert: (class class canUnderstand: #tView_new:).
	self 
		assert: (class class >> #tView_new:) sourceCode 
		equals: 'tView_new: bounds

	self ffiCall: #(tv_TView* tv_TView_new_1(tv_TRect* bounds))'
]

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitMethodAddsMethodToClass [
	| visitor class element |
	
	element := self translatedUnitTvision elementAtPath: { 'TView'. 'dragView(TEvent &, uchar, TRect &, TPoint, TPoint)' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	self addClass: element parent visitor: visitor.
	
	visitor visitMethod: element.
	
	class := self class environment classNamed: 'TvTView'.
	self assert: (class canUnderstand: #dragViewEvent:mode:limits:minSize:maxSize:).
	self 
		assert: (class >> ##dragViewEvent:mode:limits:minSize:maxSize:) sourceCode 
		equals: 'dragViewEvent: event mode: mode limits: limits minSize: minSize maxSize: maxSize

	self ffiCall: #(void tv_TView_dragView(tv_TView* self, tv_TEvent* event, tv_uchar mode, tv_TRect* limits, tv_TPoint* minSize, tv_TPoint* maxSize))'
]

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitTypedefWithCallback [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'utils'. 'NoiseMapCallback' }.
	
	visitor := CigPharoVisitor newForTest.
	visitor visitTypedef: element.

	self 
		assert: visitor types keys first
		equals: 'nu_noise_utils_NoiseMapCallback'.
	
	self 
		assert: visitor types values first
		equals: 'FFICallback'
]

{ #category : 'tests' }
CigPharoVisitorTest >> testVisitTypedefWithUint [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'uint' }.
	
	visitor := CigPharoVisitor newForTest.
	visitor visitTypedef: element.
	
	self 
		assert: visitor types keys first
		equals: 'no_noise_uint'.
		
	self 
		assert: visitor types values first
		equals: '#uint'
]