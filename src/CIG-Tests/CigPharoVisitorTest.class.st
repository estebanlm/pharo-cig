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
	(CigPharoClassGenerator newFile: aVisitor file element: aClass) generate
]

{ #category : 'tests - base' }
CigPharoVisitorTest >> testAddFFILibrary [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	"base classes will call addFFILibrary: in the correct order"
	visitor addBaseClasses: self translatedUnitNoiseutils.
	
	class := self class environment classNamed: 'LibGeneratedForTest'.
	self assert: class notNil.
	self assert: (class methods anySatisfy: [ :each | each selector = #unix64LibraryName ]).
	self assert: (class methods anySatisfy: [ :each | each selector = #win32LibraryName ]).
	self assert: (class methods anySatisfy: [ :each | each selector = #macLibraryName ])
]

{ #category : 'tests - base' }
CigPharoVisitorTest >> testAddFFILibraryWhenCPPUsesBindings [
	| visitor class |
	
	self skip. "to fix when resuming c++"
	
	visitor := CigPharoVisitor newForTestAsCPP.
	visitor addBaseClasses: self translatedUnitNoiseutils.
	
	class := self class environment classNamed: 'LibGeneratedForTest'.
	self assert: class notNil.
	self assert: (class methods anySatisfy: [ :each | each selector = #unix64LibraryName ]).
	self assert: ((class >> #unix64LibraryName) sourceCode includesSubstring: 'GeneratedForTest_bindings.so')
]

{ #category : 'tests - base' }
CigPharoVisitorTest >> testAddFFILibraryWhenCUsesLibrary [
	| visitor class |
	
	visitor := CigPharoVisitor newForTestAsC.
	visitor addBaseClasses: self translatedUnitRaylib.
	
	class := self class environment classNamed: 'LibGeneratedForTest'.
	self assert: class notNil.
	self assert: (class methods anySatisfy: [ :each | each selector = #unix64LibraryName ]).
	self assert: ((class >> #unix64LibraryName) sourceCode includesSubstring: 'libGeneratedForTest.so')
]

{ #category : 'tests - base' }
CigPharoVisitorTest >> testAddFFITrait [
	| visitor trait |
	
	visitor := CigPharoVisitor newForTest.
	visitor addFFITrait: self translatedUnitNoiseutils.
	
	trait := self class environment classNamed: 'LibTGeneratedForTest'.
	self assert: trait notNil.
	self assert: (trait methods anySatisfy: [ :each | each selector = #ffiLibraryName ]).
	self assert: (trait class methods anySatisfy: [ :each | each selector = #ffiLibraryName ]).

]

{ #category : 'tests - base' }
CigPharoVisitorTest >> testAddFFITypesClass [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	visitor addFFITypesClass: self translatedUnitNoiseutils.
	
	class := self class environment classNamed: 'XxGeneratedForTestTypedef'.
	self assert: class notNil
]

{ #category : 'tests - struct' }
CigPharoVisitorTest >> testArrayTypeIsAddedWhenStructWithArrayTypesIsCreated [
	| element visitor |

	element := self translatedUnitRaylib elementAtPath: { 'AutomationEvent' }.
	visitor := CigPharoVisitor newForTest.	
	visitor addBaseClasses: element root.
	
	visitor visitStructure: element.

	self assert: (visitor types includesKey: 'int_4')
]

{ #category : 'tests - struct' }
CigPharoVisitorTest >> testArrayTypeUsesGeneratedTypeOnStructure [
	| element visitor class |

	element := self translatedUnitRaylib elementAtPath: { 'AutomationEvent' }.
	visitor := CigPharoVisitor newForTest.	
	visitor addBaseClasses: element root.
	
	visitor visitStructure: element.
	class := self class environment classNamed: 'XxAutomationEvent'.

	self assert: class notNil.
	
	self 
		assert: (class class >> #fieldsDesc) sourceCode
		equals: 'fieldsDesc

	^ #(
	uint frame;
	uint type;
	int_4 params
	)'
]

{ #category : 'tests - base' }
CigPharoVisitorTest >> testEnsureBaseClassesIncludeNamespaceTypedefs [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitNoiseutils .
	visitor ensureBaseObjectClass: self translatedUnitNoiseutils.

	class := self class environment classNamed: 'XxBaseObject'.
	self assert: class notNil.
	
	self assert: (class sharedPoolNames asArray includes: #XxGeneratedForTestTypedef)
]

{ #category : 'tests - base' }
CigPharoVisitorTest >> testEnsureBaseEnumerationClass [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitTvision.

	class := self class environment classNamed: 'XxEnumeration'.
	self assert: class isNil.
	
	visitor ensureBaseEnumerationClass: self translatedUnitTvision.

	class := self class environment classNamed: 'XxEnumeration'.
	self assert: class notNil
]

{ #category : 'tests - base' }
CigPharoVisitorTest >> testEnsureBaseObjectClass [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitTvision.

	class := self class environment classNamed: 'XxBaseObject'.
	self assert: class isNil.
	
	visitor ensureBaseObjectClass: self translatedUnitTvision.

	class := self class environment classNamed: 'XxBaseObject'.
	self assert: class notNil
]

{ #category : 'tests - base' }
CigPharoVisitorTest >> testEnsureBaseObjectClassIncludesBaseMethods [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitTvision.

	visitor ensureBaseObjectClass: self translatedUnitTvision.

	class := self class environment classNamed: 'XxBaseObject'.
	self assert: class notNil.
	self assert: (class canUnderstand: #initialize).
	self assert: (class canUnderstand: #finalize).
	self assert: (class canUnderstand: #dispose).
	self assert: (class canUnderstand: #autoRelease)
]

{ #category : 'tests - base' }
CigPharoVisitorTest >> testEnsureBaseStructureClass [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitTvision.

	class := self class environment classNamed: 'XxStructure'.
	self assert: class isNil.
	
	visitor ensureBaseStructureClass: self translatedUnitTvision.

	class := self class environment classNamed: 'XxStructure'.
	self assert: class notNil
]

{ #category : 'tests - base' }
CigPharoVisitorTest >> testEnsureBaseUnionClass [
	| visitor class |
	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitTvision.

	class := self class environment classNamed: 'XxUnion'.
	self assert: class isNil.
	
	visitor ensureBaseUnionClass: self translatedUnitTvision.

	class := self class environment classNamed: 'XxUnion'.
	self assert: class notNil
]

{ #category : 'tests - class' }
CigPharoVisitorTest >> testVisitClassAddsClassDisposeMethod [
	| visitor class element |
	
	self skip. "to fix when resuming c++"
	
	element := self translatedUnitTvision elementAtPath: { 'TView' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitClass: element.
	
	class := self class environment classNamed: 'XxTView'.
	self assert: class notNil.
	self assert: (class methodDict at: #dispose ifAbsent: [ nil ]) notNil.
	self 
		assert: (class >> #dispose) sourceCode 
		equals: 'dispose

	self ffiCall: #(void xx_TView_dispose(xx_TView* self))'
]

{ #category : 'tests - class' }
CigPharoVisitorTest >> testVisitClassAddsClassToDefaultNamespace [
	| visitor class element |
	
	self skip. "to fix when resuming c++"
	
	element := self translatedUnitTvision elementAtPath: { 'TView' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitClass: element.
	
	class := self class environment classNamed: 'XxTView'.
	self assert: class notNil.
	self assert: class packageTag name equals: #Base	
]

{ #category : 'tests - class' }
CigPharoVisitorTest >> testVisitClassAddsClassToNamespace [
	| visitor class element |
	
	self skip. "to fix when resuming c++"
	
	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'Image' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitClass: element.
	
	class := self class environment classNamed: 'XxImage'.
	self assert: class notNil.
	self assert: class packageTag name equals: #Utils
]

{ #category : 'tests - class' }
CigPharoVisitorTest >> testVisitClassAddsClassWithCorrectSuperclass [
	| visitor class subclass element subElement |
	
	self skip. "to fix when resuming c++"
	
	element := self translatedUnitTvision elementAtPath: { 'TView' }. 
	subElement := self translatedUnitTvision elementAtPath: { 'TFrame' }.
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitClass: element.
	visitor visitClass: subElement.
	
	class := self class environment classNamed: 'XxTView'.
	subclass := self class environment classNamed: 'XxTFrame'.

	self assert: subclass superclass equals: class
]

{ #category : 'tests - class' }
CigPharoVisitorTest >> testVisitClassRegisterType [
	| visitor typedefClass class element |
	
	self skip. "to fix when resuming c++"
	
	element := self translatedUnitTvision elementAtPath: { 'TView' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	visitor visitClass: element.
	visitor endUnit: element root.
	
	typedefClass := self class environment classNamed: 'XxGeneratedForTestTypedef'.
	class := self class environment classNamed: 'XxTView'.
	self assert: typedefClass notNil.
	self assert: (typedefClass includesKey: #xx_TView).
	self assert: (typedefClass bindingOf: #xx_TView) value equals: class
]

{ #category : 'tests - classtemplate' }
CigPharoVisitorTest >> testVisitClassTemplateAddClassAndSubclasses [
	| visitor class subclass element |
	
	self skip. "to fix when resuming c++"
	
	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitClassTemplate: element.
	
	class := self class environment classNamed: 'XxTSpan'.
	self assert: class notNil.
	
	subclass := self class environment classNamed: 'XxTSpanChar'.
	self assert: subclass notNil.
	self assert: subclass superclass equals: class.
	
	subclass := self class environment classNamed: 'XxTSpanTScreenCell'.
	self assert: subclass notNil.
	self assert: subclass superclass equals: class.
	
	subclass := self class environment classNamed: 'XxTSpanUint32_t'.
	self assert: subclass notNil.
	self assert: subclass superclass equals: class
]

{ #category : 'tests - class' }
CigPharoVisitorTest >> testVisitClassWithManyConstructorsDisambiguatesName [
	| visitor class element constructors |
	
	self skip. "to fix when resuming c++"
	
	element := self translatedUnitTvision elementAtPath: { 'TView' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitClass: element.
	class := (self class environment classNamed: 'XxTView') class.
	constructors := class methodDict keys select: [ :each | each beginsWith: 'tView_' ].
	self assert: constructors size equals: 1
]

{ #category : 'tests - enum' }
CigPharoVisitorTest >> testVisitEnumGenerateClass [
	| visitor element enum |
	
	element := self translatedUnitTvision elementAtPath: { 'TVTransfer' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitEnum: element.
	
	enum := self class environment classNamed: 'XxTVTransfer'.
	self assert: enum notNil.
	
	self assert: (enum class canUnderstand: #enumDecl).
	self 
		assert: (enum class >> #enumDecl) sourceCode
		equals: 'enumDecl

	^ #(
	vtDataSize 0
	vtSetData 1
	vtGetData 2 )'
]

{ #category : 'tests - enum' }
CigPharoVisitorTest >> testVisitEnumRegisterType [
	| visitor element typedefClass enum |
	
	element := self translatedUnitTvision elementAtPath: { 'TVTransfer' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	visitor visitEnum: element.
	visitor endUnit: element root.
	
	typedefClass := self class environment classNamed: 'XxGeneratedForTestTypedef'.
	enum := self class environment classNamed: 'XxTVTransfer'.	
	self assert: typedefClass notNil.
	self assert: (typedefClass includesKey: #xx_TVTransfer).
	self assert: (typedefClass bindingOf: #xx_TVTransfer) value equals: enum
]

{ #category : 'tests - function' }
CigPharoVisitorTest >> testVisitFunctionAddsFunctionToLibrary [
	| visitor class element |
	
	element := self translatedUnitTvision elementAtPath: { 'fexpand(char *)' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitTvision.
	class := self class environment classNamed: 'LibGeneratedForTest'.
	
	visitor visitFunction: element.
	
	self assert: (class canUnderstand: #fexpand:).
	self 
		assert: (class >> #fexpand:) sourceCode 
		equals: 'fexpand: rpath

	self ffiCall: #(void xx_fexpand_1(char* rpath))'
]

{ #category : 'tests - function' }
CigPharoVisitorTest >> testVisitFunctionWithArrayParameterAddsArrayType [

	self skip. "I do not remember why I added it (to see later) :P"
	self fail
]

{ #category : 'tests - function' }
CigPharoVisitorTest >> testVisitFunctionWithNameEndingWithSameNameAsParameterDoesNotDuplicates [
	| element template |

	element := self translatedUnitRaylib elementAtPath: { 'DrawText(const char *, int, int, int, Color)' }.
	template := element phTemplate.
	
	self 
		assert: template generateHeader
		equals: 'drawText: text posX: posX posY: posY fontSize: fontSize color: color'
	
]

{ #category : 'tests - function' }
CigPharoVisitorTest >> testVisitFunctionWithStructureGeneratesCallWithoutPrefix [
	| visitor class element |
	
	element := self translatedUnitRaylib elementAtPath: { 'ClearBackground(Color)' }. 
	visitor := CigPharoVisitor newForTestAsC.
	visitor addBaseClasses: self translatedUnitRaylib.
	class := self class environment classNamed: 'LibGeneratedForTest'.
	
	visitor visitFunction: element.
	
	self assert: (class canUnderstand: #clearBackground:).
	self 
		assert: (class >> #clearBackground:) sourceCode 
		equals: 'clearBackground: color

	self ffiCall: #(void ClearBackground(Color color))'
]

{ #category : 'tests - macro' }
CigPharoVisitorTest >> testVisitMacroDefinition [
	| unit element visitor |

	unit := self newUnit: '#define MACRO 42'.
	element := unit elements first.
	
	visitor := CigPharoVisitor newForTestAsC.	
	visitor visitMacroDefinition: element.
	
	self assert: visitor constants asArray equals: #('MACRO')
]

{ #category : 'tests - macro' }
CigPharoVisitorTest >> testVisitMacroDefinitionSkipsFunctionLike [
	| unit element visitor |

	unit := self newUnit: '#define MACRO(x) somefunction(x)'.
	element := unit elements first.
	
	visitor := CigPharoVisitor newForTestAsC.	
	visitor visitMacroDefinition: element.
	
	self assertEmpty: visitor constants
]

{ #category : 'tests - method' }
CigPharoVisitorTest >> testVisitMethodAddsClassMethodToClassSide [
	| visitor class element |
	
	element := self translatedUnitTvision elementAtPath: { 'TView'. 'enableCommand(ushort)' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	self addClass: element parent visitor: visitor.
	
	visitor visitMethod: element.
	
	class := self class environment classNamed: 'XxTView'.

	self assert: (class class canUnderstand: #enableCommand:).
	self 
		assert: (class class >> #enableCommand:) sourceCode 
		equals: 'enableCommand: command

	self ffiCall: #(void xx_TView_enableCommand(xx_ushort command))'
]

{ #category : 'tests - method' }
CigPharoVisitorTest >> testVisitMethodAddsConstructorToClassSide [
	| visitor class element |
	
	element := self translatedUnitTvision elementAtPath: { 'TView'. 'TView(const TRect &)' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	self addClass: element parent visitor: visitor.
	
	visitor visitConstructor: element.
	
	class := self class environment classNamed: 'XxTView'.

	self assert: (class class canUnderstand: #newBounds:).
	self 
		assert: (class class >> #newBounds:) sourceCode 
		equals: 'newBounds: bounds

	^ (self tView_1_new: bounds) initialize'.
	
	self assert: (class class canUnderstand: #tView_1_new:).
	self 
		assert: (class class >> #tView_1_new:) sourceCode 
		equals: 'tView_1_new: bounds

	self ffiCall: #(xx_TView* xx_TView_new_1(xx_TRect* bounds))'
]

{ #category : 'tests - method' }
CigPharoVisitorTest >> testVisitMethodAddsMethodToClass [
	| visitor class element |
	
	element := self translatedUnitTvision elementAtPath: { 'TView'. 'dragView(TEvent &, uchar, TRect &, TPoint, TPoint)' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	self addClass: element parent visitor: visitor.
	
	visitor visitMethod: element.
	
	class := self class environment classNamed: 'XxTView'.
	self assert: (class canUnderstand: #dragViewEvent:mode:limits:minSize:maxSize:).
	self 
		assert: (class >> ##dragViewEvent:mode:limits:minSize:maxSize:) sourceCode 
		equals: 'dragViewEvent: event mode: mode limits: limits minSize: minSize maxSize: maxSize

	self ffiCall: #(void xx_TView_dragView(xx_TView* self, xx_TEvent* event, xx_uchar mode, xx_TRect* limits, xx_TPoint* minSize, xx_TPoint* maxSize))'
]

{ #category : 'tests - namespace' }
CigPharoVisitorTest >> testVisitNamespaceAddsNamespaceClass [
	| visitor class element |
	
	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	"using the generator because the visit will (should) visit all namespace 
	 elements and that's not what I want to test :)
	 but this may suppose a problem if the behavior of visitNamespace: is 
	 changed"
	(CigPharoNamespaceGenerator newFile: visitor file element: element) generate.
	
	class := self class environment classNamed: 'XxUtilsNamespace'.
	self assert: class notNil.
	self assert: (class class canUnderstand: #cppPrefix).
	self assert: (class class canUnderstand: #cppHeader).
	self assert: (class class canUnderstand: #cppName).
	self assert: (class class canUnderstand: #typedef).
	
	self assert: class packageTag name equals: #Utils
]

{ #category : 'tests - namespace' }
CigPharoVisitorTest >> testVisitNamespaceAddsNamespaceWithPrefix [
	| visitor class element |
	
	element := self translatedUnitNoiseutils elementAtPath: { 'noise' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	"using the generator because the visit will (should) visit all namespace 
	 elements and that's not what I want to test :)
	 but this may suppose a problem if the behavior of visitNamespace: is 
	 changed"
	(CigPharoNamespaceGenerator newFile: visitor file element: element) generate.
	
	class := self class environment classNamed: 'XxNoiseNamespace'.
	self assert: class notNil
]

{ #category : 'tests - struct' }
CigPharoVisitorTest >> testVisitStructureGenerateSimpleStructure [
	| element visitor class |

	element := self translatedUnitTvision elementAtPath: { 'TResourceItem' }.
	visitor := CigPharoVisitor newForTest.	
	visitor addBaseClasses: element root.
	
	visitor visitStructure: element.
	class := self class environment classNamed: 'XxTResourceItem'.

	self assert: class notNil.
	
	self 
		assert: (class class >> #fieldsDesc) sourceCode
		equals: 'fieldsDesc

	^ #(
	int32_t pos;
	int32_t size;
	char* key
	)'
]

{ #category : 'tests - struct' }
CigPharoVisitorTest >> testVisitStructureGenerateStructureAndUnion [
	| element visitor class nestedClass |

	element := self translatedUnitTvision elementAtPath: { 'MessageEvent' }.
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitTvision.
	
	visitor visitStructure: element.
	class := self class environment classNamed: 'XxMessageEvent'.
	
	self assert: class notNil.	
	self 
		assert: (class class >> #fieldsDesc) sourceCode
		equals: 'fieldsDesc

	^ #(
	xx_ushort command;
	XxMessageEventUnion1 union1
	)'.
	
	nestedClass := self class environment classNamed: 'XxMessageEventUnion1'.
	self assert: nestedClass notNil.	
	self 
		assert: (nestedClass class >> #fieldsDesc) sourceCode
		equals: 'fieldsDesc

	^ #(
	void* infoPtr;
	int32_t infoLong;
	xx_ushort infoWord;
	short infoInt;
	xx_uchar infoByte;
	char infoChar
	)'
]

{ #category : 'tests - struct' }
CigPharoVisitorTest >> testVisitStructureGenerateStructureAndUnionInC [
	| element visitor class nestedClass |

	element := self translatedUnitOpenSSL elementAtPath: { 'bio_poll_descriptor_st' }.
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitOpenSSL.
	
	visitor visitStructure: element.
	class := self class environment classNamed: 'XxBioPollDescriptorSt'.
	self assert: class notNil.	
	nestedClass := self class environment classNamed: 'XxBioPollDescriptorStUnion1'.
	self assert: nestedClass notNil
]

{ #category : 'tests - struct' }
CigPharoVisitorTest >> testVisitStructureInitializeStruct [
	| element visitor class |

	element := self translatedUnitTvision elementAtPath: { 'TResourceItem' }.
	visitor := CigPharoVisitor newForTest.	
	visitor addBaseClasses: element root.
	visitor visitStructure: element.
	visitor endUnit: element root.
	
	class := self class environment classNamed: 'XxTResourceItem'.
	self assert: class notNil.
	self assert: class classPool keys equals: #(OFFSET_KEY OFFSET_SIZE OFFSET_POS)
]

{ #category : 'tests - struct' }
CigPharoVisitorTest >> testVisitStructureRegisterType [
	| element visitor class typedefClass |

	element := self translatedUnitTvision elementAtPath: { 'TResourceItem' }.
	visitor := CigPharoVisitor newForTest.	
	visitor addBaseClasses: element root.
	visitor visitStructure: element.
	visitor endUnit: element root.
	
	typedefClass := self class environment classNamed: 'XxGeneratedForTestTypedef'.
	class := self class environment classNamed: 'XxTResourceItem'.
	self assert: typedefClass notNil.
	self assert: (typedefClass includesKey: #xx_TResourceItem).
	self assert: (typedefClass bindingOf: #xx_TResourceItem) value equals: class
]

{ #category : 'tests - struct' }
CigPharoVisitorTest >> testVisitStructureWithAnonymousUnionRegisterType [
	| element visitor class typedefClass |

	element := self translatedUnitOpenSSL elementAtPath: { 'bio_poll_descriptor_st' }.
	visitor := CigPharoVisitor newForTest.	
	visitor addBaseClasses: element root.
	"I need this to make the union pass :)"
	visitor registerDeclaration: #SSL as: '#void'.
	visitor visitStructure: element.
	visitor endUnit: element root.
	
	typedefClass := self class environment classNamed: 'XxGeneratedForTestTypedef'.
	class := self class environment classNamed: 'XxBioPollDescriptorSt'.
	self assert: typedefClass notNil.
	self assert: (typedefClass includesKey: #bio_poll_descriptor_st).
	self assert: (typedefClass bindingOf: #bio_poll_descriptor_st) value equals: class
]

{ #category : 'tests - struct' }
CigPharoVisitorTest >> testVisitStructureWithNamedUnionRegisterType [
	| element visitor class typedefClass |

	element := self translatedUnitOpenSSL elementAtPath: { 'lhash_st_ERR_STRING_DATA' }.
	visitor := CigPharoVisitor newForTest.	
	visitor addBaseClasses: element root.
	visitor visitStructure: element.
	visitor endUnit: element root.
	
	typedefClass := self class environment classNamed: 'XxGeneratedForTestTypedef'.
	class := self class environment classNamed: 'XxLhERRSTRINGDATADummy'.
	self assert: typedefClass notNil.
	self assert: (typedefClass includesKey: #lhash_st_ERR_STRING_DATA_lh_ERR_STRING_DATA_dummy).
	self 
		assert: (typedefClass bindingOf: #lhash_st_ERR_STRING_DATA_lh_ERR_STRING_DATA_dummy) value 
		equals: class
]

{ #category : 'tests - typedef' }
CigPharoVisitorTest >> testVisitTypedefIsAddedToTypes [
	| element visitor class |

	element := self translatedUnitNoise elementAtPath: { 'noise'. 'uint' }.	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	visitor visitTypedef: element.
	visitor endUnit: element root.
	
	class := self class environment classNamed: 'XxGeneratedForTestTypedef'.
	self assert: (class includesKey: #xx_noise_uint).
	self assert: (class localBindingOf: #xx_noise_uint) value equals: #uint
]

{ #category : 'tests - typedef' }
CigPharoVisitorTest >> testVisitTypedefSkipsHomonym [
	| element visitor |

	element := self translatedUnitRaylib 
		findElementMatching: [ :anElement | 
			anElement kind = CigTypedef kind
			and: [ anElement name = 'Vector2' ] ].
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitTypedef: element.

	self assert: visitor types isEmpty
]

{ #category : 'tests - typedef' }
CigPharoVisitorTest >> testVisitTypedefToExistingStructure [
	| element visitor |

	element := self translatedUnitRaylib elementAtPath: { 'Quaternion' }.	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitTypedef: element.

	self 
		assert: visitor types keys first
		equals: 'Quaternion'.
		
	self 
		assert: visitor types values first
		equals: 'XxVector4'
]

{ #category : 'tests - typedef' }
CigPharoVisitorTest >> testVisitTypedefUlong [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'ulong' }.	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitTypedef: element.

	self 
		assert: visitor types keys first
		equals: 'xx_ulong'.
		
	self 
		assert: visitor types values first
		equals: '#ulong'
]

{ #category : 'tests - typedef' }
CigPharoVisitorTest >> testVisitTypedefWithCallback [
	| element visitor |

	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'NoiseMapCallback' }.
	
	visitor := CigPharoVisitor newForTest.
	visitor visitTypedef: element.

	self 
		assert: visitor types keys first
		equals: 'xx_noise_utils_NoiseMapCallback'.
	
	self 
		assert: visitor types values first
		equals: 'FFICallback'
]

{ #category : 'tests - typedef' }
CigPharoVisitorTest >> testVisitTypedefWithStruct [
	| element visitor |

	element := self translatedUnitOpenSSL elementAtPath: { 'ssl_crock_st' }.	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitTypedef: element.

	self 
		assert: visitor types keys first
		equals: 'ssl_crock_st'.
		
	self 
		assert: visitor types values first
		equals: '#''ssl_st *'''
]

{ #category : 'tests - typedef' }
CigPharoVisitorTest >> testVisitTypedefWithUint [
	| element visitor |

	element := self translatedUnitNoise elementAtPath: { 'noise'. 'uint' }.	
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: element root.
	
	visitor visitTypedef: element.

	self 
		assert: visitor types keys first
		equals: 'xx_noise_uint'.
		
	self 
		assert: visitor types values first
		equals: '#uint'
]

{ #category : 'tests - function' }
CigPharoVisitorTest >> testVisitVariadic [
	| unit element visitor class |
	
	unit := CigCLibraryGenerator new 
		packageName: 'Unit';
		prefix: 'Unit';
		importUnit: '/* Nothing, I just want the variadics */';
		cVariadic: 'int printf(char *fmt, char *value)' as: #printf:string:;
		cVariadic: 'int printf(char *fmt, long value)' as: #printf:long:;
		translateUnit.
	element := unit elementAtPath: { 'printf(char *fmt, char *value)' }. 
	visitor := CigPharoVisitor newForTest.
	visitor addBaseClasses: self translatedUnitTvision.
	class := self class environment classNamed: 'LibGeneratedForTest'.
	
	visitor visitVariadic: element.
	
	self assert: (class canUnderstand: #printf:string:).
	self 
		assert: (class >> #printf:string:) sourceCode 
		equals: 'printf: fmt string: value

	^ self ffiCall: #(int printf(char *fmt, char *value))'
]
