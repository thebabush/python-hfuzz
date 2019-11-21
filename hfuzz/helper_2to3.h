#ifndef HFUZZ_HELPER_2TO3_H
#define HFUZZ_HELPER_2TO3_H

#include <Python.h>

#if PY_MAJOR_VERSION >= 3
static inline PyObject* hfuzz_mem2py(void *ptr, Py_ssize_t size) {
  return PyMemoryView_FromMemory((char *)ptr, size, PyBUF_READ);
}
#else
static inline PyObject* hfuzz_mem2py(void *ptr, Py_ssize_t size) {
  return PyBuffer_FromMemory(ptr, size);
}
#endif

#endif // HFUZZ_HELPER_2TO3_H

