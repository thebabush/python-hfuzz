# -*- Mode: Cython -*-

import os

from libc.stdint cimport *


cdef extern from "helper.h":
    cdef enum:
        _HF_PC_GUARD_MAX


#TODO(babush): is there a better way?
cdef extern from "helper_2to3.h":
    object hfuzz_mem2py(void *ptr, Py_ssize_t size)


cdef extern void HonggfuzzFetchData(const uint8_t** buf_ptr, size_t* len_ptr)
cdef extern void __cyg_profile_func_enter(uintptr_t func, uintptr_t caller)
cdef extern void __cyg_profile_func_exit(uintptr_t func, uintptr_t caller)
cdef extern void hfuzz_trace_cmp1(uintptr_t pc, uint8_t Arg1, uint8_t Arg2)
cdef extern void hfuzz_trace_cmp2(uintptr_t pc, uint16_t Arg1, uint16_t Arg2)
cdef extern void hfuzz_trace_cmp4(uintptr_t pc, uint32_t Arg1, uint32_t Arg2)
cdef extern void hfuzz_trace_cmp8(uintptr_t pc, uint64_t Arg1, uint64_t Arg2)
cdef extern void __sanitizer_cov_trace_pc_guard(uint32_t* guard)
cdef extern void hfuzz_trace_pc(uintptr_t pc)
cdef extern void hfuzzInstrumentInit()
cdef extern void instrumentClearNewCov()


class HFuzzException(Exception):
    pass


_initialized = False


class HFuzz(object):
    def __init__(self):
        global _initialized
        if _initialized:
            raise HFuzzException('HFuzz already initalized!')
        _initialized = True
        hfuzzInstrumentInit()

    def persistent(self, callback):
        cdef const uint8_t* buff = <uint8_t*>0
        cdef       size_t   size = 0
        instrumentClearNewCov()
        while True:
            HonggfuzzFetchData(&buff, &size)
            view = hfuzz_mem2py(<void*>buff, size)
            callback(view)

    def trace_cmp(self, pc, arg1, arg2, size):
        if size == 1:
            hfuzz_trace_cmp1(pc, arg1, arg2)
        elif size == 2:
            hfuzz_trace_cmp2(pc, arg1, arg2)
        elif size == 4:
            hfuzz_trace_cmp4(pc, arg1, arg2)
        elif size == 8:
            hfuzz_trace_cmp8(pc, arg1, arg2)
        else:
            raise HFuzzException('Unknown trace_cmp size')

    def trace_cmp1(self, pc, arg1, arg2):
        hfuzz_trace_cmp1(pc, arg1, arg2)

    def trace_cmp2(self, pc, arg1, arg2):
        hfuzz_trace_cmp2(pc, arg1, arg2)

    def trace_cmp4(self, pc, arg1, arg2):
        hfuzz_trace_cmp4(pc, arg1, arg2)

    def trace_cmp8(self, pc, arg1, arg2):
        hfuzz_trace_cmp8(pc, arg1, arg2)

    def trace_edge(self, pc):
        cdef uint32_t guard = pc
        guard %= _HF_PC_GUARD_MAX
        __sanitizer_cov_trace_pc_guard(&guard)

    def trace_pc(self, pc):
        hfuzz_trace_pc(pc)

