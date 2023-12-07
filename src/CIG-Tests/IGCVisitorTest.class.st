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
	
	self assert: cast equals: '(noise_module_Module*)&' 
]

{ #category : 'tests' }
IGCVisitorTest >> testCCastToReturnWhenClassInDifferentNamespace [
	| element cast |
	
	element := self elementAtPath: { 'noise'. 'model'. 'Cylinder'. 'GetModule()' }.
	
	cast := IGCGenerator new cCastToReturn: element resolveReturnType.
	
	self assert: cast equals: '(noise_module_Module*)&' 
]

{ #category : 'tests' }
IGCVisitorTest >> testCCastToReturnWhenEnum [
	| element cast |
	
	element := self elementAtPath: { 'noise'. 'module'. 'Billow'. 'GetNoiseQuality()' }.
	
	cast := IGCGenerator new cCastToReturn: element resolveReturnType.
	
	self assert: cast equals: '(noise_NoiseQuality)' 
]

{ #category : 'tests' }
IGCVisitorTest >> testVisitMethodParameterStdStringCastsCorrectly [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'utils'. 'WriterBMP'. 'SetDestFilename(const std::string &)' }.
	
	visitor := IGCVisitor newForTest.
	visitor visitMethod: element.
	
	self 
		assert: visitor hStream contents trimmed
		equals: 'void noise_utils_WriterBMP_SetDestFilename(noise_utils_WriterBMP* self, const char* filename);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'void noise_utils_WriterBMP_SetDestFilename(noise_utils_WriterBMP* self, const char* filename) {
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
		equals: 'noise_utils_Color* noise_utils_Image_GetBorderValue(noise_utils_Image* self);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'noise_utils_Color* noise_utils_Image_GetBorderValue(noise_utils_Image* self) {
	auto _tmp = ((noise::utils::Image*)self)->GetBorderValue();
	auto _result = new noise::utils::Color();
	memcpy(_result, &_tmp, sizeof(noise::utils::Color));
	return (noise_utils_Color*)_result;
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
		equals: 'const noise_utils_Color* noise_utils_Image_GetConstSlabPtr_2(noise_utils_Image* self, int row);'.
	
	self 
		assert: visitor cStream contents trimmed 
		equals: 'const noise_utils_Color* noise_utils_Image_GetConstSlabPtr_2(noise_utils_Image* self, int row) {
	return (noise_utils_Color*)(((noise::utils::Image*)self)->GetConstSlabPtr(row));
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
		equals: 'char* noise_utils_WriterBMP_GetDestFilename(noise_utils_WriterBMP* self);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'char* noise_utils_WriterBMP_GetDestFilename(noise_utils_WriterBMP* self) {
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
		equals: 'void TCellChar_moveWideCharTrail(TCellChar* self);'.
	
	self 
		assert: visitor cStream contents trimmed
		equals: 'void TCellChar_moveWideCharTrail(TCellChar* self) {
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
IGCVisitorTest >> testVisitTypedefWithCallback [
	| element visitor |

	element := self elementAtPath: { 'noise'. 'utils'. 'NoiseMapCallback' }.
	
	visitor := IGCVisitor newForTest.
	visitor visitTypedef: element.
	
	self 
		assert: visitor hStream contents trimmed 
		equals: 'typedef void* noise_utils_NoiseMapCallback;'
]
