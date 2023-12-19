Class {
	#name : 'CXTypeKind',
	#superclass : 'SharedPool',
	#classVars : [
		'CXType_Accum',
		'CXType_Atomic',
		'CXType_Attributed',
		'CXType_Auto',
		'CXType_BFloat16',
		'CXType_BTFTagAttributed',
		'CXType_BlockPointer',
		'CXType_Bool',
		'CXType_Char16',
		'CXType_Char32',
		'CXType_Char_S',
		'CXType_Char_U',
		'CXType_Complex',
		'CXType_ConstantArray',
		'CXType_Dependent',
		'CXType_DependentSizedArray',
		'CXType_Double',
		'CXType_Elaborated',
		'CXType_Enum',
		'CXType_ExtVector',
		'CXType_FirstBuiltin',
		'CXType_Float',
		'CXType_Float128',
		'CXType_Float16',
		'CXType_FunctionNoProto',
		'CXType_FunctionProto',
		'CXType_Half',
		'CXType_Ibm128',
		'CXType_IncompleteArray',
		'CXType_Int',
		'CXType_Int128',
		'CXType_Invalid',
		'CXType_LValueReference',
		'CXType_LastBuiltin',
		'CXType_Long',
		'CXType_LongAccum',
		'CXType_LongDouble',
		'CXType_LongLong',
		'CXType_MemberPointer',
		'CXType_NullPtr',
		'CXType_OCLEvent',
		'CXType_OCLImage1dArrayRO',
		'CXType_OCLImage1dArrayRW',
		'CXType_OCLImage1dArrayWO',
		'CXType_OCLImage1dBufferRO',
		'CXType_OCLImage1dBufferRW',
		'CXType_OCLImage1dBufferWO',
		'CXType_OCLImage1dRO',
		'CXType_OCLImage1dRW',
		'CXType_OCLImage1dWO',
		'CXType_OCLImage2dArrayDepthRO',
		'CXType_OCLImage2dArrayDepthRW',
		'CXType_OCLImage2dArrayDepthWO',
		'CXType_OCLImage2dArrayMSAADepthRO',
		'CXType_OCLImage2dArrayMSAADepthRW',
		'CXType_OCLImage2dArrayMSAADepthWO',
		'CXType_OCLImage2dArrayMSAARO',
		'CXType_OCLImage2dArrayMSAARW',
		'CXType_OCLImage2dArrayMSAAWO',
		'CXType_OCLImage2dArrayRO',
		'CXType_OCLImage2dArrayRW',
		'CXType_OCLImage2dArrayWO',
		'CXType_OCLImage2dDepthRO',
		'CXType_OCLImage2dDepthRW',
		'CXType_OCLImage2dDepthWO',
		'CXType_OCLImage2dMSAADepthRO',
		'CXType_OCLImage2dMSAADepthRW',
		'CXType_OCLImage2dMSAADepthWO',
		'CXType_OCLImage2dMSAARO',
		'CXType_OCLImage2dMSAARW',
		'CXType_OCLImage2dMSAAWO',
		'CXType_OCLImage2dRO',
		'CXType_OCLImage2dRW',
		'CXType_OCLImage2dWO',
		'CXType_OCLImage3dRO',
		'CXType_OCLImage3dRW',
		'CXType_OCLImage3dWO',
		'CXType_OCLIntelSubgroupAVCImeDualRefStreamin',
		'CXType_OCLIntelSubgroupAVCImeDualReferenceStreamin',
		'CXType_OCLIntelSubgroupAVCImePayload',
		'CXType_OCLIntelSubgroupAVCImeResult',
		'CXType_OCLIntelSubgroupAVCImeResultDualRefStreamout',
		'CXType_OCLIntelSubgroupAVCImeResultDualReferenceStreamout',
		'CXType_OCLIntelSubgroupAVCImeResultSingleRefStreamout',
		'CXType_OCLIntelSubgroupAVCImeResultSingleReferenceStreamout',
		'CXType_OCLIntelSubgroupAVCImeSingleRefStreamin',
		'CXType_OCLIntelSubgroupAVCImeSingleReferenceStreamin',
		'CXType_OCLIntelSubgroupAVCMcePayload',
		'CXType_OCLIntelSubgroupAVCMceResult',
		'CXType_OCLIntelSubgroupAVCRefPayload',
		'CXType_OCLIntelSubgroupAVCRefResult',
		'CXType_OCLIntelSubgroupAVCSicPayload',
		'CXType_OCLIntelSubgroupAVCSicResult',
		'CXType_OCLQueue',
		'CXType_OCLReserveID',
		'CXType_OCLSampler',
		'CXType_ObjCClass',
		'CXType_ObjCId',
		'CXType_ObjCInterface',
		'CXType_ObjCObject',
		'CXType_ObjCObjectPointer',
		'CXType_ObjCSel',
		'CXType_ObjCTypeParam',
		'CXType_Overload',
		'CXType_Pipe',
		'CXType_Pointer',
		'CXType_RValueReference',
		'CXType_Record',
		'CXType_SChar',
		'CXType_Short',
		'CXType_ShortAccum',
		'CXType_Typedef',
		'CXType_UAccum',
		'CXType_UChar',
		'CXType_UInt',
		'CXType_UInt128',
		'CXType_ULong',
		'CXType_ULongAccum',
		'CXType_ULongLong',
		'CXType_UShort',
		'CXType_UShortAccum',
		'CXType_Unexposed',
		'CXType_VariableArray',
		'CXType_Vector',
		'CXType_Void',
		'CXType_WChar'
	],
	#category : 'CIG-LibClang',
	#package : 'CIG-LibClang'
}

{ #category : 'class initialization' }
CXTypeKind class >> initialize [

	CXType_Invalid := 0.
	CXType_Unexposed := 1.
	CXType_Bool := 3.
	CXType_Char_U := 4.
	CXType_UChar := 5.
	CXType_Char16 := 6.
	CXType_Char32 := 7.
	CXType_UShort := 8.
	CXType_UInt := 9.
	CXType_ULong := 10.
	CXType_ULongLong := 11.
	CXType_UInt128 := 12.
	CXType_Char_S := 13.
	CXType_SChar := 14.
	CXType_WChar := 15.
	CXType_Short := 16.
	CXType_Int := 17.
	CXType_Long := 18.
	CXType_LongLong := 19.
	CXType_Int128 := 20.
	CXType_Float := 21.
	CXType_Double := 22.
	CXType_LongDouble := 23.
	CXType_NullPtr := 24.
	CXType_Overload := 25.
	CXType_Dependent := 26.
	CXType_ObjCId := 27.
	CXType_ObjCClass := 28.
	CXType_ObjCSel := 29.
	CXType_Float128 := 30.
	CXType_Half := 31.
	CXType_Float16 := 32.
	CXType_ShortAccum := 33.
	CXType_Accum := 34.
	CXType_LongAccum := 35.
	CXType_UShortAccum := 36.
	CXType_UAccum := 37.
	CXType_ULongAccum := 38.
	CXType_BFloat16 := 39.
	CXType_Ibm128 := 40.
	CXType_FirstBuiltin := CXType_Void.
	CXType_LastBuiltin := CXType_Ibm128.
	CXType_Complex := 100.
	CXType_Pointer := 101.
	CXType_BlockPointer := 102.
	CXType_LValueReference := 103.
	CXType_RValueReference := 104.
	CXType_Record := 105.
	CXType_Enum := 106.
	CXType_Typedef := 107.
	CXType_ObjCInterface := 108.
	CXType_ObjCObjectPointer := 109.
	CXType_FunctionNoProto := 110.
	CXType_FunctionProto := 111.
	CXType_ConstantArray := 112.
	CXType_Vector := 113.
	CXType_IncompleteArray := 114.
	CXType_VariableArray := 115.
	CXType_DependentSizedArray := 116.
	CXType_MemberPointer := 117.
	CXType_Auto := 118.
	CXType_Elaborated := 119.
	CXType_Pipe := 120.
	CXType_OCLImage1dRO := 121.
	CXType_OCLImage1dArrayRO := 122.
	CXType_OCLImage1dBufferRO := 123.
	CXType_OCLImage2dRO := 124.
	CXType_OCLImage2dArrayRO := 125.
	CXType_OCLImage2dDepthRO := 126.
	CXType_OCLImage2dArrayDepthRO := 127.
	CXType_OCLImage2dMSAARO := 128.
	CXType_OCLImage2dArrayMSAARO := 129.
	CXType_OCLImage2dMSAADepthRO := 130.
	CXType_OCLImage2dArrayMSAADepthRO := 131.
	CXType_OCLImage3dRO := 132.
	CXType_OCLImage1dWO := 133.
	CXType_OCLImage1dArrayWO := 134.
	CXType_OCLImage1dBufferWO := 135.
	CXType_OCLImage2dWO := 136.
	CXType_OCLImage2dArrayWO := 137.
	CXType_OCLImage2dDepthWO := 138.
	CXType_OCLImage2dArrayDepthWO := 139.
	CXType_OCLImage2dMSAAWO := 140.
	CXType_OCLImage2dArrayMSAAWO := 141.
	CXType_OCLImage2dMSAADepthWO := 142.
	CXType_OCLImage2dArrayMSAADepthWO := 143.
	CXType_OCLImage3dWO := 144.
	CXType_OCLImage1dRW := 145.
	CXType_OCLImage1dArrayRW := 146.
	CXType_OCLImage1dBufferRW := 147.
	CXType_OCLImage2dRW := 148.
	CXType_OCLImage2dArrayRW := 149.
	CXType_OCLImage2dDepthRW := 150.
	CXType_OCLImage2dArrayDepthRW := 151.
	CXType_OCLImage2dMSAARW := 152.
	CXType_OCLImage2dArrayMSAARW := 153.
	CXType_OCLImage2dMSAADepthRW := 154.
	CXType_OCLImage2dArrayMSAADepthRW := 155.
	CXType_OCLImage3dRW := 156.
	CXType_OCLSampler := 157.
	CXType_OCLEvent := 158.
	CXType_OCLQueue := 159.
	CXType_OCLReserveID := 160.
	CXType_ObjCObject := 161.
	CXType_ObjCTypeParam := 162.
	CXType_Attributed := 163.
	CXType_OCLIntelSubgroupAVCMcePayload := 164.
	CXType_OCLIntelSubgroupAVCImePayload := 165.
	CXType_OCLIntelSubgroupAVCRefPayload := 166.
	CXType_OCLIntelSubgroupAVCSicPayload := 167.
	CXType_OCLIntelSubgroupAVCMceResult := 168.
	CXType_OCLIntelSubgroupAVCImeResult := 169.
	CXType_OCLIntelSubgroupAVCRefResult := 170.
	CXType_OCLIntelSubgroupAVCSicResult := 171.
	CXType_OCLIntelSubgroupAVCImeResultSingleReferenceStreamout := 172.
	CXType_OCLIntelSubgroupAVCImeResultDualReferenceStreamout := 173.
	CXType_OCLIntelSubgroupAVCImeSingleReferenceStreamin := 174.
	CXType_OCLIntelSubgroupAVCImeDualReferenceStreamin := 175.
	CXType_OCLIntelSubgroupAVCImeResultSingleRefStreamout := 172.
	CXType_OCLIntelSubgroupAVCImeResultDualRefStreamout := 173.
	CXType_OCLIntelSubgroupAVCImeSingleRefStreamin := 174.
	CXType_OCLIntelSubgroupAVCImeDualRefStreamin := 175.
	CXType_ExtVector := 176.
	CXType_Atomic := 177.
	CXType_BTFTagAttributed := 178
]
