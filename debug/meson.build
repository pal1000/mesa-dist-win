project('llvm', ['cpp'])

cpp = meson.get_compiler('cpp')

_deps = []
_search = join_paths(meson.current_source_dir(), '../../../llvm/x64/lib')
foreach d : ['LLVMCodeGen', 'LLVMScalarOpts', 'LLVMAnalysis',
             'LLVMTransformUtils', 'LLVMCore', 'LLVMX86CodeGen',
             'LLVMSelectionDAG', 'LLVMipo', 'LLVMAsmPrinter',
             'LLVMInstCombine', 'LLVMInstrumentation', 'LLVMMC',
             'LLVMGlobalISel', 'LLVMObjectYAML', 'LLVMDebugInfoPDB',
             'LLVMVectorize', 'LLVMPasses', 'LLVMSupport',
             'LLVMLTO', 'LLVMObject', 'LLVMDebugInfoCodeView',
             'LLVMDebugInfoDWARF', 'LLVMOrcJIT', 'LLVMProfileData',
             'LLVMObjCARCOpts', 'LLVMBitReader', 'LLVMCoroutines',
             'LLVMBitWriter', 'LLVMRuntimeDyld', 'LLVMMIRParser',
             'LLVMX86Desc', 'LLVMAsmParser', 'LLVMTableGen',
             'LLVMFuzzMutate', 'LLVMLinker', 'LLVMMCParser',
             'LLVMExecutionEngine', 'LLVMCoverage', 'LLVMInterpreter',
             'LLVMTarget', 'LLVMX86AsmParser', 'LLVMSymbolize',
             'LLVMDebugInfoMSF', 'LLVMMCJIT', 'LLVMXRay',
             'LLVMX86AsmPrinter', 'LLVMX86Disassembler',
             'LLVMMCDisassembler', 'LLVMOption', 'LLVMIRReader',
             'LLVMDlltoolDriver', 'LLVMDemangle',
             'LLVMBinaryFormat', 'LLVMLineEditor',
             'LLVMWindowsManifest', 'LLVMX86Info', 'LLVMX86Utils']
  _deps += cpp.find_library(d, dirs : _search)
endforeach

ext_llvm = declare_dependency(
  include_directories : include_directories(join_paths(meson.current_source_dir(), '../../../llvm/x64/include')),
  dependencies : _deps,
  version : '6.0.1',
)

irbuilder_h = files(join_paths(meson.current_source_dir(), '../../../llvm/x64/include/llvm/IR/IRBuilder.h'))