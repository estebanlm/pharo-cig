Class {
	#name : 'CigCVisitorTest',
	#superclass : 'CigBaseTest',
	#category : 'CIG-Tests-C',
	#package : 'CIG-Tests',
	#tag : 'C'
}

{ #category : 'tests - class' }
CigCVisitorTest >> testVisitClassGeneratesATypedef [
	| element visitor |
			
	element := self translatedUnitTvision elementAtPath: { 'TView' }.
	visitor := CigCHeaderDeclareVisitor newForTest.
	visitor visitClass: element.
	"just first line because TView has inner enums"
	self 
		assert: visitor hStream contents trimmed lines first
		equals: 'typedef void tv_TView;'.
		
	element := self translatedUnitNoise elementAtPath: { 'noise'. 'module'. 'Module' }.
	visitor := CigCHeaderDeclareVisitor newForTest.
	visitor visitClass: element.
	self 
		assert: visitor hStream contents trimmed
		equals: 'typedef void no_noise_module_Module;'
]

{ #category : 'tests - classtemplate' }
CigCVisitorTest >> testVisitClassTemplateGeneratesABaseClassAndSubclasses [
	| element visitor result |

	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitClassTemplate: element.
	
	result := visitor hStream contents.
	
	"check for different generated methods"
	self assert: (result includesSubstring: 'tv_TSpanChar* tv_TSpanChar_new_1();').
	self assert: (result includesSubstring: 'char* tv_TSpanChar_data(tv_TSpanChar* self);').
	self assert: (result includesSubstring: 'tv_TScreenCell* tv_TSpanTScreenCell_data(tv_TSpanTScreenCell* self);').
	self assert: (result includesSubstring: 'uint32_t* tv_TSpanUint32_t_data(tv_TSpanUint32_t* self);')
]

{ #category : 'tests - class' }
CigCVisitorTest >> testVisitClassTemplateGeneratesATypedefForEachDefinedType [
	| element visitor |
	
	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	
	visitor := CigCHeaderDeclareVisitor newForTest.
	visitor visitClassTemplate: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'typedef void tv_TSpan;
typedef void tv_TSpanChar;
typedef void tv_TSpanTScreenCell;
typedef void tv_TSpanUint32_t;'
]

{ #category : 'tests - classtemplate' }
CigCVisitorTest >> testVisitClassTemplateGeneratesDefinedSpecialization [
	| unit element visitor result |

	unit := CigCppLibraryGenerator new
		prefix: 'xx';
		from: 'array' import: #('std::array');
		cSpecialize: 'std::array<char, 4>';
		withoutSpecialElements;
		translateUnit.

	element := unit elementAtPath: { 'std'. 'array' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitClassTemplate: element.
	
	result := visitor hStream contents.
	
	"check for different generated methods"
	self assert: (result includesSubstring: 'void xx_std_arrayChar4_dispose(xx_std_arrayChar4* self);')
]

{ #category : 'tests - class' }
CigCVisitorTest >> testVisitClassWithDispose [
	| element visitor |

	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'RendererNormalMap' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitClass: element.
	
	self assert: (visitor hStream contents includesSubstring: 'void nu_noise_utils_RendererNormalMap_dispose')
]

{ #category : 'tests - class' }
CigCVisitorTest >> testVisitClassWithNestedEnumEmitsEnum [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'THardwareInfo' }.
	
	visitor := CigCHeaderDeclareVisitor newForTest.
	visitor visitClass: element.
	
	self 
		assert: visitor hStream contents trimmed 
		equals: 'typedef void tv_THardwareInfo;
typedef THardwareInfo::ConsoleType tv_THardwareInfo_ConsoleType;
typedef THardwareInfo::PlatformType tv_THardwareInfo_PlatformType;'
]

{ #category : 'tests - class' }
CigCVisitorTest >> testVisitClassWithTypedefGenerateTypedefs [
	| element visitor content |
			
	element := self translatedUnitTvision elementAtPath: { 'pstream' }.
	visitor := CigCHeaderDeclareVisitor newForTest.
	visitor visitClass: element.
	
	content := visitor hStream contents trimmed.
	self assert: (content includesSubstring: 'typedef void tv_pstream;').
	self assert: (content includesSubstring: 'typedef int tv_pstream_openmode;').
	self assert: (content includesSubstring: 'typedef int tv_pstream_seekdir;')
]

{ #category : 'tests - method' }
CigCVisitorTest >> testVisitConstructorWithOverloadedNewGeneratesCorrectParameters [
	| element visitor |
	
	element := self translatedUnitTvision elementAtPath: { 'TScreenCell'. 'TScreenCell()' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitConstructor: element.
	
	self 
		assert: visitor hStream contents trimmed 
		equals: 'tv_TScreenCell* tv_TScreenCell_new_1(void* p);'.
		
	self 
		assert: visitor cStream contents trimmed
		equals: 'tv_TScreenCell* tv_TScreenCell_new_1(void* p) {
	return (tv_TScreenCell*)(new (p) TScreenCell());
}'
]

{ #category : 'tests - enum' }
CigCVisitorTest >> testVisitEnumUnnamedGeneratesCorrectName [
	| element visitor |
	
	"I am not generating them for the moment"
	self skip.
	
	element := self translatedUnitTvision elements 
		detect: [ :each | each isEnum and: [ each isUnnamed ] ].
	
	visitor := CigCVisitor newForTest.
	visitor visitEnum: element.
	
	self 
		assert: visitor hStream contents trimmed lines first
		equals: 'enum tv_unnamed_enum_1 {'.
]

{ #category : 'tests - enum' }
CigCVisitorTest >> testVisitEnumWithOneLevelEmitsTypedef [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'StreamableInit' }.
	
	visitor := CigCHeaderDeclareVisitor newForTest.
	visitor visitEnum: element.
	
	self 
		assert: visitor hStream contents trimmed 
		equals: 'typedef StreamableInit tv_StreamableInit;'
]

{ #category : 'tests - function' }
CigCVisitorTest >> testVisitFunctionDisambiguate [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'fexpand(char *)' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitFunction: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'void tv_fexpand_1(char* rpath);'
]

{ #category : 'tests - function' }
CigCVisitorTest >> testVisitFunctionReturningClassGenerateCorrectMethodTemplate [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'RGBtoBIOS(TColorRGB)' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitFunction: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'tv_TColorBIOS* tv_RGBtoBIOS(tv_TColorRGB* arg1);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'tv_TColorBIOS* tv_RGBtoBIOS(tv_TColorRGB* arg1) {
	auto _result = new TColorBIOS();
	*_result = RGBtoBIOS(*(TColorRGB*)arg1);
	return (tv_TColorBIOS*)_result;
}'
]

{ #category : 'tests - function' }
CigCVisitorTest >> testVisitFunctionReturningClassWithOverloadedNewGenerateCorrectMethodTemplate [
	"classes with overloaded new cannot be created in a reliable way, we transform the 
	 function to receive an extra parameter and copying the content there"
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'getFore(const TColorAttr &)' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitFunction: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'void tv_getFore(tv_TColorAttr* attr, tv_TColorDesired* result);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'void tv_getFore(tv_TColorAttr* attr, tv_TColorDesired* result) {
	*(TColorDesired*)result = getFore(*(TColorAttr*)attr);
}'
]

{ #category : 'tests - function' }
CigCVisitorTest >> testVisitFunctionWithVariadicArgumentGeneratesCorrectFunction [
	| element visitor |

	"I am skipping variadic functions for the moment, as there is no easy way to 
	 forward them to the c++ side. Using gcc this would ne something like this (calling printf): 

void f(const char *format, ...) {
	void* args = __builtin_apply_args();
	void* result = __builtin_apply((void (*)())printf, args, 1000);
	__builtin_return(result);
}	
	"
	self skip.

	element := self translatedUnitTvision elementAtPath: { 'fmtStr(const char *, ...)' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitFunction: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'char* tv_fmtStr(const char* format, ...);'.
		
	self 
		assert: visitor cStream contents trimmed
		equals: 'char* tv_fmtStr(char* format, ...) {
	void* _args = __builtin_apply_args();
	void* _result = __builtin_apply((void (*)())fmtStr, _args, 1000);
	__builtin_return(_result);
}
'
]

{ #category : 'tests - method' }
CigCVisitorTest >> testVisitMethodDeclaredWithoutArgumentNamesGeneratesDefaultNames [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'TEditor'. 'insertBuffer(const char *, uint, uint, Boolean, Boolean)' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'Boolean tv_TEditor_insertBuffer(tv_TEditor* self, const char* arg1, tv_uint arg2, tv_uint arg3, Boolean arg4, Boolean arg5);'
]

{ #category : 'tests - method' }
CigCVisitorTest >> testVisitMethodParameterStdStringCastsCorrectly [
	| element visitor |

	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'WriterBMP'. 'SetDestFilename(const std::string &)' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'void nu_noise_utils_WriterBMP_SetDestFilename(nu_noise_utils_WriterBMP* self, char* filename);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'void nu_noise_utils_WriterBMP_SetDestFilename(nu_noise_utils_WriterBMP* self, char* filename) {
	((noise::utils::WriterBMP*)self)->SetDestFilename(std::string(filename));
}'
]

{ #category : 'tests - method' }
CigCVisitorTest >> testVisitMethodReturningClassGenerateCorrectMethodTemplate [
	| element visitor |

	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'Image'. 'GetBorderValue()' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'nu_noise_utils_Color* nu_noise_utils_Image_GetBorderValue(nu_noise_utils_Image* self);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'nu_noise_utils_Color* nu_noise_utils_Image_GetBorderValue(nu_noise_utils_Image* self) {
	auto _result = new noise::utils::Color();
	*_result = ((noise::utils::Image*)self)->GetBorderValue();
	return (nu_noise_utils_Color*)_result;
}'
]

{ #category : 'tests - method' }
CigCVisitorTest >> testVisitMethodReturningClassPtrGeneratesCorrectReturnType [
	| element visitor |

	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'Image'. 'GetConstSlabPtr(int)' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'nu_noise_utils_Color* nu_noise_utils_Image_GetConstSlabPtr_2(nu_noise_utils_Image* self, int row);'.
	
	self 
		assert: visitor cStream contents trimmed 
		equals: 'nu_noise_utils_Color* nu_noise_utils_Image_GetConstSlabPtr_2(nu_noise_utils_Image* self, int row) {
	return (nu_noise_utils_Color*)(((noise::utils::Image*)self)->GetConstSlabPtr(row));
}'
]

{ #category : 'tests - method' }
CigCVisitorTest >> testVisitMethodReturningStdStringCastsCorrectly [
	| element visitor |

	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'WriterBMP'. 'GetDestFilename()' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'char* nu_noise_utils_WriterBMP_GetDestFilename(nu_noise_utils_WriterBMP* self);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'char* nu_noise_utils_WriterBMP_GetDestFilename(nu_noise_utils_WriterBMP* self) {
	auto _tmp = ((noise::utils::WriterBMP*)self)->GetDestFilename();
	auto _result = _tmp.c_str();
	return (char*)_result;
}'
]

{ #category : 'tests - method' }
CigCVisitorTest >> testVisitMethodWithClassTemplateCastsCorrectly [
	| element visitor |
	
	element := self translatedUnitTvision elementAtPath: { 'TText'. 'drawStr(TSpan<TScreenCell>, int, TStringView, int)' }.

	visitor := CigCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'int tv_TText_drawStr_1(tv_TSpan* cells, size_t indent, tv_TStringView* text, int textIndent);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'int tv_TText_drawStr_1(tv_TSpan* cells, size_t indent, tv_TStringView* text, int textIndent) {
	return TText::drawStr(*(TSpan<TScreenCell>*)cells, indent, *(TStringView*)text, textIndent);
}'
]

{ #category : 'tests - method' }
CigCVisitorTest >> testVisitMethodWithReferenceTypeCastsCorrectly [
	| element visitor |
	
	element := self translatedUnitTvision elementAtPath: { 'TText'. 'scroll(TStringView, int, Boolean, int &, int &)' }.

	visitor := CigCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'void tv_TText_scroll_2(tv_TStringView* text, int count, Boolean includeIncomplete, size_t* length, size_t* width);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'void tv_TText_scroll_2(tv_TStringView* text, int count, Boolean includeIncomplete, size_t* length, size_t* width) {
	TText::scroll(*(TStringView*)text, count, includeIncomplete, *length, *width);
}'
]

{ #category : 'tests - method' }
CigCVisitorTest >> testVisitMethodWithReturnClassInstance [
	| element visitor |

	element := self translatedUnitFinalcut elementAtPath: { 'finalcut'. 'FWidget'. 'termToWidgetPos(const FPoint &)' }.
	visitor := CigCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'fc_finalcut_FPoint* fc_finalcut_FWidget_termToWidgetPos(fc_finalcut_FWidget* self, fc_finalcut_FPoint* arg1);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'fc_finalcut_FPoint* fc_finalcut_FWidget_termToWidgetPos(fc_finalcut_FWidget* self, fc_finalcut_FPoint* arg1) {
	auto _result = new finalcut::FPoint();
	*_result = ((finalcut::FWidget*)self)->termToWidgetPos(*(finalcut::FPoint*)arg1);
	return (fc_finalcut_FPoint*)_result;
}'
]

{ #category : 'tests - method' }
CigCVisitorTest >> testVisitMethodWithTypeReference [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'TCellChar'. 'moveWideCharTrail()' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'void tv_TCellChar_moveWideCharTrail(tv_TCellChar* self);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'void tv_TCellChar_moveWideCharTrail(tv_TCellChar* self) {
	((TCellChar*)self)->moveWideCharTrail();
}'
]

{ #category : 'tests - struct' }
CigCVisitorTest >> testVisitOpaqueStructureGeneratesATypedef [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'TTimer' }.
	
	visitor := CigCHeaderDeclareVisitor newForTest.
	visitor visitStructure: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'typedef void tv_TTimer;'.
]

{ #category : 'tests - method' }
CigCVisitorTest >> testVisitStaticMethodsGeneratesClassSideFunction [
	| element visitor |
	
	element := self translatedUnitTvision elementAtPath: { 'TText'. 'scroll(TStringView, int, Boolean)' }.

	visitor := CigCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'int tv_TText_scroll_1(tv_TStringView* text, int count, Boolean includeIncomplete);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'int tv_TText_scroll_1(tv_TStringView* text, int count, Boolean includeIncomplete) {
	return TText::scroll(*(TStringView*)text, count, includeIncomplete);
}'
]

{ #category : 'tests - struct' }
CigCVisitorTest >> testVisitStructureWithAnonymousUnionGeneratesCorrectCStruct [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'MessageEvent' }.
	
	visitor := CigCVisitor newForTest.
	visitor visitStructure: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'struct tv_MessageEvent {
	tv_ushort command;
	union {
		void* infoPtr;
		int32_t infoLong;
		tv_ushort infoWord;
		short infoInt;
		tv_uchar infoByte;
		char infoChar;
	};
};'.
]

{ #category : 'tests - typedef' }
CigCVisitorTest >> testVisitTypedefWithArrayDeclaresCorrectly [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'TScrollChars' }.
	
	visitor := CigCHeaderDeclareVisitor newForTest.
	visitor visitTypedef: element.
	
	self 
		assert: visitor hStream contents trimmed 
		equals: 'typedef char* tv_TScrollChars;'
]

{ #category : 'tests - typedef' }
CigCVisitorTest >> testVisitTypedefWithCallback [
	| element visitor |

	element := self translatedUnitNoiseutils elementAtPath: { 'noise'. 'utils'. 'NoiseMapCallback' }.
	
	visitor := CigCHeaderDeclareVisitor newForTest.
	visitor visitTypedef: element.
	
	self 
		assert: visitor hStream contents trimmed 
		equals: 'typedef void* nu_noise_utils_NoiseMapCallback;'
]

{ #category : 'tests - typedef' }
CigCVisitorTest >> testVisitUsingDeclarationGeneratesTypedefToTypedef [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'streampos' }.
	
	visitor := CigCHeaderDeclareVisitor newForTest.
	visitor visitUsingDeclaration: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'typedef std::streampos tv_streampos;'.

]
