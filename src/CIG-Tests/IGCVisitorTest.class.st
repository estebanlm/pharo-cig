Class {
	#name : 'IGCVisitorTest',
	#superclass : 'IGBaseTest',
	#category : 'CIG-Tests',
	#package : 'CIG-Tests'
}

{ #category : 'tests' }
IGCVisitorTest >> testArgumentCastAsCPP [
	| element param cast |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Billow'. 'SetNoiseQuality(noise::NoiseQuality)' }.
	
	param := element parameters first.
	
	cast := IGCGenerator new argumentCastToCPP: param.
	
	self assert: cast equals: '(noise::NoiseQuality)noiseQuality' 
]

{ #category : 'tests' }
IGCVisitorTest >> testArgumentCastAsCPPWhenClassInDifferentNamespace [
	| element param cast |
	
	element := self elementAtPath: { 'noise'. 'model'. 'Cylinder'. 'SetModule(const module::Module &)' }.
	
	param := element parameters first.
	
	cast := IGCGenerator new argumentCastToCPP: param.
	
	self assert: cast equals: '*(noise::module::Module*)module' 
]

{ #category : 'tests' }
IGCVisitorTest >> testArgumentCastAsCPPWhenClassReference [
	| element param cast |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'SetSourceModule(int, const Module &)' }.
	
	param := element parameters second.
	
	cast := IGCGenerator new argumentCastToCPP: param.
	
	self assert: cast equals: '*(noise::module::Module*)sourceModule'
]

{ #category : 'tests' }
IGCVisitorTest >> testCCastToReturnWhenClass [
	| element cast |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Module'. 'GetSourceModule(int)' }.
	
	cast := IGCGenerator new cCastToReturn: element resolveReturnType.
	
	self assert: cast equals: '(no_noise_module_Module*)&' 
]

{ #category : 'tests' }
IGCVisitorTest >> testCCastToReturnWhenClassInDifferentNamespace [
	| element cast |
	
	element := self elementAtPath: { 'noise'. 'model'. 'Cylinder'. 'GetModule()' }.
	
	cast := IGCGenerator new cCastToReturn: element resolveReturnType.
	
	self assert: cast equals: '(no_noise_module_Module*)&' 
]

{ #category : 'tests' }
IGCVisitorTest >> testCCastToReturnWhenEnum [
	| element cast |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Billow'. 'GetNoiseQuality()' }.
	
	cast := IGCGenerator new cCastToReturn: element resolveReturnType.
	
	self assert: cast equals: '(no_noise_NoiseQuality)' 
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitClassGeneratesATypedef [
	| element visitor |
			
	element := self translatedUnitTvision elementAtPath: { 'TView' }.
	visitor := IGCHeaderDeclareVisitor newForTest.
	visitor visitClass: element.
	self 
		assert: visitor hStream contents trimmed
		equals: 'typedef void tv_TView;'.
		
	element := self elementAtPath: { 'noise'. 'module'. 'Module' }.
	visitor := IGCHeaderDeclareVisitor newForTest.
	visitor visitClass: element.
	self 
		assert: visitor hStream contents trimmed
		equals: 'typedef void no_noise_module_Module;'
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitClassTemplateGeneratesATypedefForEachDefinedType [
	| element visitor |
	
	element := self translatedUnitTvision elementAtPath: { 'TSpan<T>' }.
	
	visitor := IGCHeaderDeclareVisitor newForTest.
	visitor visitClassTemplate: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'typedef void tv_TSpan;
typedef void tv_TSpanChar;
typedef void tv_TSpanTScreenCell;'
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitClassWithTypedefGenerateTypedefs [
	| element visitor |
			
	element := self translatedUnitTvision elementAtPath: { 'pstream' }.
	visitor := IGCHeaderDeclareVisitor newForTest.
	visitor visitClass: element.
	self 
		assert: visitor hStream contents trimmed
		equals: 'typedef void tv_pstream;
typedef int tv_pstream_openmode;
typedef int tv_pstream_seekdir;'
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitEnumUnnamedGeneratesCorrectName [
	| element visitor |
	
	self skip.
	
	element := self translatedUnitTvision elements 
		detect: [ :each | each isEnum and: [ each isUnnamed ] ].
	
	visitor := IGCVisitor newForTest.
	visitor visitEnum: element.
	
	self 
		assert: visitor hStream contents trimmed lines first
		equals: 'enum tv_unnamed_enum_1 {'.
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitEnumWithOneLevelEmitsTypedef [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'StreamableInit' }.
	
	visitor := IGCVisitor newForTest.
	visitor visitEnum: element.
	
	self 
		assert: visitor hStream contents trimmed 
		equals: 'typedef StreamableInit tv_StreamableInit;'
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitFunctionDisambiguate [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'fexpand(char *)' }.
	
	visitor := IGCVisitor newForTest.
	visitor visitFunction: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'void tv_fexpand_1(char* rpath);'
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitMethodDeclaredWithoutArgumentNamesGeneratesDefaultNames [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'TEditor'. 'insertBuffer(const char *, uint, uint, Boolean, Boolean)' }.
	
	visitor := IGCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'tv_Boolean tv_TEditor_insertBuffer(tv_TEditor* self, const char* arg1, tv_uint arg2, tv_uint arg3, tv_Boolean arg4, tv_Boolean arg5);'
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitMethodParameterStdStringCastsCorrectly [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'utils'. 'WriterBMP'. 'SetDestFilename(const std::string &)' }.
	
	visitor := IGCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'void nu_noise_utils_WriterBMP_SetDestFilename(nu_noise_utils_WriterBMP* self, const char* filename);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'void nu_noise_utils_WriterBMP_SetDestFilename(nu_noise_utils_WriterBMP* self, const char* filename) {
	((noise::utils::WriterBMP*)self)->SetDestFilename(std::string(filename));
}'
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitMethodReturningClassGenerateCorrectMethodTemplate [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'utils'. 'Image'. 'GetBorderValue()' }.
	
	visitor := IGCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'nu_noise_utils_Color* nu_noise_utils_Image_GetBorderValue(nu_noise_utils_Image* self);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'nu_noise_utils_Color* nu_noise_utils_Image_GetBorderValue(nu_noise_utils_Image* self) {
	auto _tmp = ((noise::utils::Image*)self)->GetBorderValue();
	auto _result = new noise::utils::Color();
	memcpy(_result, &_tmp, sizeof(noise::utils::Color));
	return (nu_noise_utils_Color*)_result;
}'
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitMethodReturningClassPtrGeneratesCorrectReturnType [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'utils'. 'Image'. 'GetConstSlabPtr(int)' }.
	
	visitor := IGCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'const nu_noise_utils_Color* nu_noise_utils_Image_GetConstSlabPtr_2(nu_noise_utils_Image* self, int row);'.
	
	self 
		assert: visitor cStream contents trimmed 
		equals: 'const nu_noise_utils_Color* nu_noise_utils_Image_GetConstSlabPtr_2(nu_noise_utils_Image* self, int row) {
	return (nu_noise_utils_Color*)(((noise::utils::Image*)self)->GetConstSlabPtr(row));
}'
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitMethodReturningStdStringCastsCorrectly [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'utils'. 'WriterBMP'. 'GetDestFilename()' }.
	
	visitor := IGCVisitor newForTest.
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

{ #category : 'tests' }
IGCVisitorTest >> testVisitMethodWithTypeReferenceNowQualifyingReturnType [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'TCellChar'. 'moveWideCharTrail()' }.
	
	visitor := IGCVisitor newForTest.
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

{ #category : 'tests' }
IGCVisitorTest >> testVisitStructureSkipTemplateSpecialization [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'std'. 'hash<TStringView>' }.
	
	visitor := IGCVisitor newForTest.
	visitor visitStructure: element.
	
	self assert: visitor cStream contents trimmed isEmpty
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitTypedefWithArrayDeclaresCorrectly [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'TScrollChars' }.
	
	visitor := IGCHeaderDeclareVisitor newForTest.
	visitor visitTypedef: element.
	
	self 
		assert: visitor hStream contents trimmed 
		equals: 'typedef char* tv_TScrollChars;'
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitTypedefWithCallback [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'utils'. 'NoiseMapCallback' }.
	
	visitor := IGCHeaderDeclareVisitor newForTest.
	visitor visitTypedef: element.
	
	self 
		assert: visitor hStream contents trimmed 
		equals: 'typedef void* nu_noise_utils_NoiseMapCallback;'
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitUsingDeclarationGeneratesTypedefToTypedef [
	| element visitor |

	element := self translatedUnitTvision elementAtPath: { 'streampos' }.
	
	visitor := IGCHeaderDeclareVisitor newForTest.
	visitor visitUsingDeclaration: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'typedef std::streampos tv_streampos;'.

]
