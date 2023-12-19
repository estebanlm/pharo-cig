Class {
	#name : 'CXCursorKind',
	#superclass : 'SharedPool',
	#classVars : [
		'CXCursor_AddrLabelExpr',
		'CXCursor_AlignedAttr',
		'CXCursor_AnnotateAttr',
		'CXCursor_ArraySubscriptExpr',
		'CXCursor_AsmLabelAttr',
		'CXCursor_AsmStmt',
		'CXCursor_BinaryOperator',
		'CXCursor_BlockExpr',
		'CXCursor_BreakStmt',
		'CXCursor_BuiltinBitCastExpr',
		'CXCursor_CStyleCastExpr',
		'CXCursor_CUDAConstantAttr',
		'CXCursor_CUDADeviceAttr',
		'CXCursor_CUDAGlobalAttr',
		'CXCursor_CUDAHostAttr',
		'CXCursor_CUDASharedAttr',
		'CXCursor_CXXAccessSpecifier',
		'CXCursor_CXXAddrspaceCastExpr',
		'CXCursor_CXXBaseSpecifier',
		'CXCursor_CXXBoolLiteralExpr',
		'CXCursor_CXXCatchStmt',
		'CXCursor_CXXConstCastExpr',
		'CXCursor_CXXDeleteExpr',
		'CXCursor_CXXDynamicCastExpr',
		'CXCursor_CXXFinalAttr',
		'CXCursor_CXXForRangeStmt',
		'CXCursor_CXXFunctionalCastExpr',
		'CXCursor_CXXMethod',
		'CXCursor_CXXNewExpr',
		'CXCursor_CXXNullPtrLiteralExpr',
		'CXCursor_CXXOverrideAttr',
		'CXCursor_CXXParenListInitExpr',
		'CXCursor_CXXReinterpretCastExpr',
		'CXCursor_CXXStaticCastExpr',
		'CXCursor_CXXThisExpr',
		'CXCursor_CXXThrowExpr',
		'CXCursor_CXXTryStmt',
		'CXCursor_CXXTypeidExpr',
		'CXCursor_CallExpr',
		'CXCursor_CaseStmt',
		'CXCursor_CharacterLiteral',
		'CXCursor_ClassDecl',
		'CXCursor_ClassTemplate',
		'CXCursor_ClassTemplatePartialSpecialization',
		'CXCursor_CompoundAssignOperator',
		'CXCursor_CompoundLiteralExpr',
		'CXCursor_CompoundStmt',
		'CXCursor_ConceptDecl',
		'CXCursor_ConceptSpecializationExpr',
		'CXCursor_ConditionalOperator',
		'CXCursor_ConstAttr',
		'CXCursor_Constructor',
		'CXCursor_ContinueStmt',
		'CXCursor_ConvergentAttr',
		'CXCursor_ConversionFunction',
		'CXCursor_DLLExport',
		'CXCursor_DLLImport',
		'CXCursor_DeclRefExpr',
		'CXCursor_DeclStmt',
		'CXCursor_DefaultStmt',
		'CXCursor_Destructor',
		'CXCursor_DoStmt',
		'CXCursor_EnumConstantDecl',
		'CXCursor_EnumDecl',
		'CXCursor_FieldDecl',
		'CXCursor_FirstAttr',
		'CXCursor_FirstDecl',
		'CXCursor_FirstExpr',
		'CXCursor_FirstExtraDecl',
		'CXCursor_FirstInvalid',
		'CXCursor_FirstPreprocessing',
		'CXCursor_FirstRef',
		'CXCursor_FirstStmt',
		'CXCursor_FixedPointLiteral',
		'CXCursor_FlagEnum',
		'CXCursor_FloatingLiteral',
		'CXCursor_ForStmt',
		'CXCursor_FriendDecl',
		'CXCursor_FunctionDecl',
		'CXCursor_FunctionTemplate',
		'CXCursor_GCCAsmStmt',
		'CXCursor_GNUNullExpr',
		'CXCursor_GenericSelectionExpr',
		'CXCursor_GotoStmt',
		'CXCursor_IBActionAttr',
		'CXCursor_IBOutletAttr',
		'CXCursor_IBOutletCollectionAttr',
		'CXCursor_IfStmt',
		'CXCursor_ImaginaryLiteral',
		'CXCursor_InclusionDirective',
		'CXCursor_IndirectGotoStmt',
		'CXCursor_InitListExpr',
		'CXCursor_IntegerLiteral',
		'CXCursor_InvalidCode',
		'CXCursor_InvalidFile',
		'CXCursor_LabelRef',
		'CXCursor_LabelStmt',
		'CXCursor_LambdaExpr',
		'CXCursor_LastAttr',
		'CXCursor_LastDecl',
		'CXCursor_LastExpr',
		'CXCursor_LastExtraDecl',
		'CXCursor_LastInvalid',
		'CXCursor_LastPreprocessing',
		'CXCursor_LastRef',
		'CXCursor_LastStmt',
		'CXCursor_LinkageSpec',
		'CXCursor_MSAsmStmt',
		'CXCursor_MacroDefinition',
		'CXCursor_MacroExpansion',
		'CXCursor_MacroInstantiation',
		'CXCursor_MemberRef',
		'CXCursor_MemberRefExpr',
		'CXCursor_ModuleImportDecl',
		'CXCursor_NSConsumed',
		'CXCursor_NSConsumesSelf',
		'CXCursor_NSReturnsAutoreleased',
		'CXCursor_NSReturnsNotRetained',
		'CXCursor_NSReturnsRetained',
		'CXCursor_Namespace',
		'CXCursor_NamespaceAlias',
		'CXCursor_NamespaceRef',
		'CXCursor_NoDeclFound',
		'CXCursor_NoDuplicateAttr',
		'CXCursor_NonTypeTemplateParameter',
		'CXCursor_NotImplemented',
		'CXCursor_NullStmt',
		'CXCursor_OMPArraySectionExpr',
		'CXCursor_OMPArrayShapingExpr',
		'CXCursor_OMPAtomicDirective',
		'CXCursor_OMPBarrierDirective',
		'CXCursor_OMPCancelDirective',
		'CXCursor_OMPCancellationPointDirective',
		'CXCursor_OMPCanonicalLoop',
		'CXCursor_OMPCriticalDirective',
		'CXCursor_OMPDepobjDirective',
		'CXCursor_OMPDispatchDirective',
		'CXCursor_OMPDistributeDirective',
		'CXCursor_OMPDistributeParallelForDirective',
		'CXCursor_OMPDistributeParallelForSimdDirective',
		'CXCursor_OMPDistributeSimdDirective',
		'CXCursor_OMPErrorDirective',
		'CXCursor_OMPFlushDirective',
		'CXCursor_OMPForDirective',
		'CXCursor_OMPForSimdDirective',
		'CXCursor_OMPGenericLoopDirective',
		'CXCursor_OMPInteropDirective',
		'CXCursor_OMPIteratorExpr',
		'CXCursor_OMPMaskedDirective',
		'CXCursor_OMPMaskedTaskLoopDirective',
		'CXCursor_OMPMaskedTaskLoopSimdDirective',
		'CXCursor_OMPMasterDirective',
		'CXCursor_OMPMasterTaskLoopDirective',
		'CXCursor_OMPMasterTaskLoopSimdDirective',
		'CXCursor_OMPMetaDirective',
		'CXCursor_OMPOrderedDirective',
		'CXCursor_OMPParallelDirective',
		'CXCursor_OMPParallelForDirective',
		'CXCursor_OMPParallelForSimdDirective',
		'CXCursor_OMPParallelGenericLoopDirective',
		'CXCursor_OMPParallelMaskedDirective',
		'CXCursor_OMPParallelMaskedTaskLoopDirective',
		'CXCursor_OMPParallelMaskedTaskLoopSimdDirective',
		'CXCursor_OMPParallelMasterDirective',
		'CXCursor_OMPParallelMasterTaskLoopDirective',
		'CXCursor_OMPParallelMasterTaskLoopSimdDirective',
		'CXCursor_OMPParallelSectionsDirective',
		'CXCursor_OMPScanDirective',
		'CXCursor_OMPScopeDirective',
		'CXCursor_OMPSectionDirective',
		'CXCursor_OMPSectionsDirective',
		'CXCursor_OMPSimdDirective',
		'CXCursor_OMPSingleDirective',
		'CXCursor_OMPTargetDataDirective',
		'CXCursor_OMPTargetDirective',
		'CXCursor_OMPTargetEnterDataDirective',
		'CXCursor_OMPTargetExitDataDirective',
		'CXCursor_OMPTargetParallelDirective',
		'CXCursor_OMPTargetParallelForDirective',
		'CXCursor_OMPTargetParallelForSimdDirective',
		'CXCursor_OMPTargetParallelGenericLoopDirective',
		'CXCursor_OMPTargetSimdDirective',
		'CXCursor_OMPTargetTeamsDirective',
		'CXCursor_OMPTargetTeamsDistributeDirective',
		'CXCursor_OMPTargetTeamsDistributeParallelForDirective',
		'CXCursor_OMPTargetTeamsDistributeParallelForSimdDirective',
		'CXCursor_OMPTargetTeamsDistributeSimdDirective',
		'CXCursor_OMPTargetTeamsGenericLoopDirective',
		'CXCursor_OMPTargetUpdateDirective',
		'CXCursor_OMPTaskDirective',
		'CXCursor_OMPTaskLoopDirective',
		'CXCursor_OMPTaskLoopSimdDirective',
		'CXCursor_OMPTaskgroupDirective',
		'CXCursor_OMPTaskwaitDirective',
		'CXCursor_OMPTaskyieldDirective',
		'CXCursor_OMPTeamsDirective',
		'CXCursor_OMPTeamsDistributeDirective',
		'CXCursor_OMPTeamsDistributeParallelForDirective',
		'CXCursor_OMPTeamsDistributeParallelForSimdDirective',
		'CXCursor_OMPTeamsDistributeSimdDirective',
		'CXCursor_OMPTeamsGenericLoopDirective',
		'CXCursor_OMPTileDirective',
		'CXCursor_OMPUnrollDirective',
		'CXCursor_ObjCAtCatchStmt',
		'CXCursor_ObjCAtFinallyStmt',
		'CXCursor_ObjCAtSynchronizedStmt',
		'CXCursor_ObjCAtThrowStmt',
		'CXCursor_ObjCAtTryStmt',
		'CXCursor_ObjCAutoreleasePoolStmt',
		'CXCursor_ObjCAvailabilityCheckExpr',
		'CXCursor_ObjCBoolLiteralExpr',
		'CXCursor_ObjCBoxable',
		'CXCursor_ObjCBridgedCastExpr',
		'CXCursor_ObjCCategoryDecl',
		'CXCursor_ObjCCategoryImplDecl',
		'CXCursor_ObjCClassMethodDecl',
		'CXCursor_ObjCClassRef',
		'CXCursor_ObjCDesignatedInitializer',
		'CXCursor_ObjCDynamicDecl',
		'CXCursor_ObjCEncodeExpr',
		'CXCursor_ObjCException',
		'CXCursor_ObjCExplicitProtocolImpl',
		'CXCursor_ObjCForCollectionStmt',
		'CXCursor_ObjCImplementationDecl',
		'CXCursor_ObjCIndependentClass',
		'CXCursor_ObjCInstanceMethodDecl',
		'CXCursor_ObjCInterfaceDecl',
		'CXCursor_ObjCIvarDecl',
		'CXCursor_ObjCMessageExpr',
		'CXCursor_ObjCNSObject',
		'CXCursor_ObjCPreciseLifetime',
		'CXCursor_ObjCPropertyDecl',
		'CXCursor_ObjCProtocolDecl',
		'CXCursor_ObjCProtocolExpr',
		'CXCursor_ObjCProtocolRef',
		'CXCursor_ObjCRequiresSuper',
		'CXCursor_ObjCReturnsInnerPointer',
		'CXCursor_ObjCRootClass',
		'CXCursor_ObjCRuntimeVisible',
		'CXCursor_ObjCSelectorExpr',
		'CXCursor_ObjCSelfExpr',
		'CXCursor_ObjCStringLiteral',
		'CXCursor_ObjCSubclassingRestricted',
		'CXCursor_ObjCSuperClassRef',
		'CXCursor_ObjCSynthesizeDecl',
		'CXCursor_OverloadCandidate',
		'CXCursor_OverloadedDeclRef',
		'CXCursor_PackExpansionExpr',
		'CXCursor_PackedAttr',
		'CXCursor_ParenExpr',
		'CXCursor_ParmDecl',
		'CXCursor_PreprocessingDirective',
		'CXCursor_PureAttr',
		'CXCursor_RequiresExpr',
		'CXCursor_ReturnStmt',
		'CXCursor_SEHExceptStmt',
		'CXCursor_SEHFinallyStmt',
		'CXCursor_SEHLeaveStmt',
		'CXCursor_SEHTryStmt',
		'CXCursor_SizeOfPackExpr',
		'CXCursor_StaticAssert',
		'CXCursor_StmtExpr',
		'CXCursor_StringLiteral',
		'CXCursor_StructDecl',
		'CXCursor_SwitchStmt',
		'CXCursor_TemplateRef',
		'CXCursor_TemplateTemplateParameter',
		'CXCursor_TemplateTypeParameter',
		'CXCursor_TranslationUnit',
		'CXCursor_TypeAliasDecl',
		'CXCursor_TypeAliasTemplateDecl',
		'CXCursor_TypeRef',
		'CXCursor_TypedefDecl',
		'CXCursor_UnaryExpr',
		'CXCursor_UnaryOperator',
		'CXCursor_UnexposedAttr',
		'CXCursor_UnexposedDecl',
		'CXCursor_UnexposedExpr',
		'CXCursor_UnexposedStmt',
		'CXCursor_UnionDecl',
		'CXCursor_UsingDeclaration',
		'CXCursor_UsingDirective',
		'CXCursor_VarDecl',
		'CXCursor_VariableRef',
		'CXCursor_VisibilityAttr',
		'CXCursor_WarnUnusedAttr',
		'CXCursor_WarnUnusedResultAttr',
		'CXCursor_WhileStmt'
	],
	#category : 'CIG-LibClang',
	#package : 'CIG-LibClang'
}

{ #category : 'class initialization' }
CXCursorKind class >> initialize [

	CXCursor_UnexposedDecl := 1.
	CXCursor_StructDecl := 2.
	CXCursor_UnionDecl := 3.
	CXCursor_ClassDecl := 4.
	CXCursor_EnumDecl := 5.
	CXCursor_FieldDecl := 6.
	CXCursor_EnumConstantDecl := 7.
	CXCursor_FunctionDecl := 8.
	CXCursor_VarDecl := 9.
	CXCursor_ParmDecl := 10.
	CXCursor_ObjCInterfaceDecl := 11.
	CXCursor_ObjCCategoryDecl := 12.
	CXCursor_ObjCProtocolDecl := 13.
	CXCursor_ObjCPropertyDecl := 14.
	CXCursor_ObjCIvarDecl := 15.
	CXCursor_ObjCInstanceMethodDecl := 16.
	CXCursor_ObjCClassMethodDecl := 17.
	CXCursor_ObjCImplementationDecl := 18.
	CXCursor_ObjCCategoryImplDecl := 19.
	CXCursor_TypedefDecl := 20.
	CXCursor_CXXMethod := 21.
	CXCursor_Namespace := 22.
	CXCursor_LinkageSpec := 23.
	CXCursor_Constructor := 24.
	CXCursor_Destructor := 25.
	CXCursor_ConversionFunction := 26.
	CXCursor_TemplateTypeParameter := 27.
	CXCursor_NonTypeTemplateParameter := 28.
	CXCursor_TemplateTemplateParameter := 29.
	CXCursor_FunctionTemplate := 30.
	CXCursor_ClassTemplate := 31.
	CXCursor_ClassTemplatePartialSpecialization := 32.
	CXCursor_NamespaceAlias := 33.
	CXCursor_UsingDirective := 34.
	CXCursor_UsingDeclaration := 35.
	CXCursor_TypeAliasDecl := 36.
	CXCursor_ObjCSynthesizeDecl := 37.
	CXCursor_ObjCDynamicDecl := 38.
	CXCursor_CXXAccessSpecifier := 39.
	CXCursor_FirstDecl := CXCursor_UnexposedDecl.
	CXCursor_LastDecl := CXCursor_CXXAccessSpecifier.
	CXCursor_FirstRef := 40.
	CXCursor_ObjCSuperClassRef := 40.
	CXCursor_ObjCProtocolRef := 41.
	CXCursor_ObjCClassRef := 42.
	CXCursor_TypeRef := 43.
	CXCursor_CXXBaseSpecifier := 44.
	CXCursor_TemplateRef := 45.
	CXCursor_NamespaceRef := 46.
	CXCursor_MemberRef := 47.
	CXCursor_LabelRef := 48.
	CXCursor_OverloadedDeclRef := 49.
	CXCursor_VariableRef := 50.
	CXCursor_LastRef := CXCursor_VariableRef.
	CXCursor_FirstInvalid := 70.
	CXCursor_InvalidFile := 70.
	CXCursor_NoDeclFound := 71.
	CXCursor_NotImplemented := 72.
	CXCursor_InvalidCode := 73.
	CXCursor_LastInvalid := CXCursor_InvalidCode.
	CXCursor_FirstExpr := 100.
	CXCursor_UnexposedExpr := 100.
	CXCursor_DeclRefExpr := 101.
	CXCursor_MemberRefExpr := 102.
	CXCursor_CallExpr := 103.
	CXCursor_ObjCMessageExpr := 104.
	CXCursor_BlockExpr := 105.
	CXCursor_IntegerLiteral := 106.
	CXCursor_FloatingLiteral := 107.
	CXCursor_ImaginaryLiteral := 108.
	CXCursor_StringLiteral := 109.
	CXCursor_CharacterLiteral := 110.
	CXCursor_ParenExpr := 111.
	CXCursor_UnaryOperator := 112.
	CXCursor_ArraySubscriptExpr := 113.
	CXCursor_BinaryOperator := 114.
	CXCursor_CompoundAssignOperator := 115.
	CXCursor_ConditionalOperator := 116.
	CXCursor_CStyleCastExpr := 117.
	CXCursor_CompoundLiteralExpr := 118.
	CXCursor_InitListExpr := 119.
	CXCursor_AddrLabelExpr := 120.
	CXCursor_StmtExpr := 121.
	CXCursor_GenericSelectionExpr := 122.
	CXCursor_GNUNullExpr := 123.
	CXCursor_CXXStaticCastExpr := 124.
	CXCursor_CXXDynamicCastExpr := 125.
	CXCursor_CXXReinterpretCastExpr := 126.
	CXCursor_CXXConstCastExpr := 127.
	CXCursor_CXXFunctionalCastExpr := 128.
	CXCursor_CXXTypeidExpr := 129.
	CXCursor_CXXBoolLiteralExpr := 130.
	CXCursor_CXXNullPtrLiteralExpr := 131.
	CXCursor_CXXThisExpr := 132.
	CXCursor_CXXThrowExpr := 133.
	CXCursor_CXXNewExpr := 134.
	CXCursor_CXXDeleteExpr := 135.
	CXCursor_UnaryExpr := 136.
	CXCursor_ObjCStringLiteral := 137.
	CXCursor_ObjCEncodeExpr := 138.
	CXCursor_ObjCSelectorExpr := 139.
	CXCursor_ObjCProtocolExpr := 140.
	CXCursor_ObjCBridgedCastExpr := 141.
	CXCursor_PackExpansionExpr := 142.
	CXCursor_SizeOfPackExpr := 143.
	CXCursor_LambdaExpr := 144.
	CXCursor_ObjCBoolLiteralExpr := 145.
	CXCursor_ObjCSelfExpr := 146.
	CXCursor_OMPArraySectionExpr := 147.
	CXCursor_ObjCAvailabilityCheckExpr := 148.
	CXCursor_FixedPointLiteral := 149.
	CXCursor_OMPArrayShapingExpr := 150.
	CXCursor_OMPIteratorExpr := 151.
	CXCursor_CXXAddrspaceCastExpr := 152.
	CXCursor_ConceptSpecializationExpr := 153.
	CXCursor_RequiresExpr := 154.
	CXCursor_CXXParenListInitExpr := 155.
	CXCursor_LastExpr := CXCursor_CXXParenListInitExpr.
	CXCursor_FirstStmt := 200.
	CXCursor_UnexposedStmt := 200.
	CXCursor_LabelStmt := 201.
	CXCursor_CompoundStmt := 202.
	CXCursor_CaseStmt := 203.
	CXCursor_DefaultStmt := 204.
	CXCursor_IfStmt := 205.
	CXCursor_SwitchStmt := 206.
	CXCursor_WhileStmt := 207.
	CXCursor_DoStmt := 208.
	CXCursor_ForStmt := 209.
	CXCursor_GotoStmt := 210.
	CXCursor_IndirectGotoStmt := 211.
	CXCursor_ContinueStmt := 212.
	CXCursor_BreakStmt := 213.
	CXCursor_ReturnStmt := 214.
	CXCursor_GCCAsmStmt := 215.
	CXCursor_AsmStmt := CXCursor_GCCAsmStmt.
	CXCursor_ObjCAtTryStmt := 216.
	CXCursor_ObjCAtCatchStmt := 217.
	CXCursor_ObjCAtFinallyStmt := 218.
	CXCursor_ObjCAtThrowStmt := 219.
	CXCursor_ObjCAtSynchronizedStmt := 220.
	CXCursor_ObjCAutoreleasePoolStmt := 221.
	CXCursor_ObjCForCollectionStmt := 222.
	CXCursor_CXXCatchStmt := 223.
	CXCursor_CXXTryStmt := 224.
	CXCursor_CXXForRangeStmt := 225.
	CXCursor_SEHTryStmt := 226.
	CXCursor_SEHExceptStmt := 227.
	CXCursor_SEHFinallyStmt := 228.
	CXCursor_MSAsmStmt := 229.
	CXCursor_NullStmt := 230.
	CXCursor_DeclStmt := 231.
	CXCursor_OMPParallelDirective := 232.
	CXCursor_OMPSimdDirective := 233.
	CXCursor_OMPForDirective := 234.
	CXCursor_OMPSectionsDirective := 235.
	CXCursor_OMPSectionDirective := 236.
	CXCursor_OMPSingleDirective := 237.
	CXCursor_OMPParallelForDirective := 238.
	CXCursor_OMPParallelSectionsDirective := 239.
	CXCursor_OMPTaskDirective := 240.
	CXCursor_OMPMasterDirective := 241.
	CXCursor_OMPCriticalDirective := 242.
	CXCursor_OMPTaskyieldDirective := 243.
	CXCursor_OMPBarrierDirective := 244.
	CXCursor_OMPTaskwaitDirective := 245.
	CXCursor_OMPFlushDirective := 246.
	CXCursor_SEHLeaveStmt := 247.
	CXCursor_OMPOrderedDirective := 248.
	CXCursor_OMPAtomicDirective := 249.
	CXCursor_OMPForSimdDirective := 250.
	CXCursor_OMPParallelForSimdDirective := 251.
	CXCursor_OMPTargetDirective := 252.
	CXCursor_OMPTeamsDirective := 253.
	CXCursor_OMPTaskgroupDirective := 254.
	CXCursor_OMPCancellationPointDirective := 255.
	CXCursor_OMPCancelDirective := 256.
	CXCursor_OMPTargetDataDirective := 257.
	CXCursor_OMPTaskLoopDirective := 258.
	CXCursor_OMPTaskLoopSimdDirective := 259.
	CXCursor_OMPDistributeDirective := 260.
	CXCursor_OMPTargetEnterDataDirective := 261.
	CXCursor_OMPTargetExitDataDirective := 262.
	CXCursor_OMPTargetParallelDirective := 263.
	CXCursor_OMPTargetParallelForDirective := 264.
	CXCursor_OMPTargetUpdateDirective := 265.
	CXCursor_OMPDistributeParallelForDirective := 266.
	CXCursor_OMPDistributeParallelForSimdDirective := 267.
	CXCursor_OMPDistributeSimdDirective := 268.
	CXCursor_OMPTargetParallelForSimdDirective := 269.
	CXCursor_OMPTargetSimdDirective := 270.
	CXCursor_OMPTeamsDistributeDirective := 271.
	CXCursor_OMPTeamsDistributeSimdDirective := 272.
	CXCursor_OMPTeamsDistributeParallelForSimdDirective := 273.
	CXCursor_OMPTeamsDistributeParallelForDirective := 274.
	CXCursor_OMPTargetTeamsDirective := 275.
	CXCursor_OMPTargetTeamsDistributeDirective := 276.
	CXCursor_OMPTargetTeamsDistributeParallelForDirective := 277.
	CXCursor_OMPTargetTeamsDistributeParallelForSimdDirective := 278.
	CXCursor_OMPTargetTeamsDistributeSimdDirective := 279.
	CXCursor_BuiltinBitCastExpr := 280.
	CXCursor_OMPMasterTaskLoopDirective := 281.
	CXCursor_OMPParallelMasterTaskLoopDirective := 282.
	CXCursor_OMPMasterTaskLoopSimdDirective := 283.
	CXCursor_OMPParallelMasterTaskLoopSimdDirective := 284.
	CXCursor_OMPParallelMasterDirective := 285.
	CXCursor_OMPDepobjDirective := 286.
	CXCursor_OMPScanDirective := 287.
	CXCursor_OMPTileDirective := 288.
	CXCursor_OMPCanonicalLoop := 289.
	CXCursor_OMPInteropDirective := 290.
	CXCursor_OMPDispatchDirective := 291.
	CXCursor_OMPMaskedDirective := 292.
	CXCursor_OMPUnrollDirective := 293.
	CXCursor_OMPMetaDirective := 294.
	CXCursor_OMPGenericLoopDirective := 295.
	CXCursor_OMPTeamsGenericLoopDirective := 296.
	CXCursor_OMPTargetTeamsGenericLoopDirective := 297.
	CXCursor_OMPParallelGenericLoopDirective := 298.
	CXCursor_OMPTargetParallelGenericLoopDirective := 299.
	CXCursor_OMPParallelMaskedDirective := 300.
	CXCursor_OMPMaskedTaskLoopDirective := 301.
	CXCursor_OMPMaskedTaskLoopSimdDirective := 302.
	CXCursor_OMPParallelMaskedTaskLoopDirective := 303.
	CXCursor_OMPParallelMaskedTaskLoopSimdDirective := 304.
	CXCursor_OMPErrorDirective := 305.
	CXCursor_OMPScopeDirective := 306.
	CXCursor_LastStmt := CXCursor_OMPScopeDirective.
	CXCursor_TranslationUnit := 350.
	CXCursor_FirstAttr := 400.
	CXCursor_UnexposedAttr := 400.
	CXCursor_IBActionAttr := 401.
	CXCursor_IBOutletAttr := 402.
	CXCursor_IBOutletCollectionAttr := 403.
	CXCursor_CXXFinalAttr := 404.
	CXCursor_CXXOverrideAttr := 405.
	CXCursor_AnnotateAttr := 406.
	CXCursor_AsmLabelAttr := 407.
	CXCursor_PackedAttr := 408.
	CXCursor_PureAttr := 409.
	CXCursor_ConstAttr := 410.
	CXCursor_NoDuplicateAttr := 411.
	CXCursor_CUDAConstantAttr := 412.
	CXCursor_CUDADeviceAttr := 413.
	CXCursor_CUDAGlobalAttr := 414.
	CXCursor_CUDAHostAttr := 415.
	CXCursor_CUDASharedAttr := 416.
	CXCursor_VisibilityAttr := 417.
	CXCursor_DLLExport := 418.
	CXCursor_DLLImport := 419.
	CXCursor_NSReturnsRetained := 420.
	CXCursor_NSReturnsNotRetained := 421.
	CXCursor_NSReturnsAutoreleased := 422.
	CXCursor_NSConsumesSelf := 423.
	CXCursor_NSConsumed := 424.
	CXCursor_ObjCException := 425.
	CXCursor_ObjCNSObject := 426.
	CXCursor_ObjCIndependentClass := 427.
	CXCursor_ObjCPreciseLifetime := 428.
	CXCursor_ObjCReturnsInnerPointer := 429.
	CXCursor_ObjCRequiresSuper := 430.
	CXCursor_ObjCRootClass := 431.
	CXCursor_ObjCSubclassingRestricted := 432.
	CXCursor_ObjCExplicitProtocolImpl := 433.
	CXCursor_ObjCDesignatedInitializer := 434.
	CXCursor_ObjCRuntimeVisible := 435.
	CXCursor_ObjCBoxable := 436.
	CXCursor_FlagEnum := 437.
	CXCursor_ConvergentAttr := 438.
	CXCursor_WarnUnusedAttr := 439.
	CXCursor_WarnUnusedResultAttr := 440.
	CXCursor_AlignedAttr := 441.
	CXCursor_LastAttr := CXCursor_AlignedAttr.
	CXCursor_PreprocessingDirective := 500.
	CXCursor_MacroDefinition := 501.
	CXCursor_MacroExpansion := 502.
	CXCursor_MacroInstantiation := CXCursor_MacroExpansion.
	CXCursor_InclusionDirective := 503.
	CXCursor_FirstPreprocessing := CXCursor_PreprocessingDirective.
	CXCursor_LastPreprocessing := CXCursor_InclusionDirective.
	CXCursor_ModuleImportDecl := 600.
	CXCursor_TypeAliasTemplateDecl := 601.
	CXCursor_StaticAssert := 602.
	CXCursor_FriendDecl := 603.
	CXCursor_ConceptDecl := 604.
	CXCursor_FirstExtraDecl := CXCursor_ModuleImportDecl.
	CXCursor_LastExtraDecl := CXCursor_ConceptDecl.
	CXCursor_OverloadCandidate := 700	
]
