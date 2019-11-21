#!/usr/bin/env python3

from distutils.core import setup, Extension
import os

from Cython.Build import cythonize


# TODO: Figure out a way to make `pip install .` work.
#       Currently it fails due to the relative path in `extra_objects`.


HFUZZ_PATH = os.getenv('HFUZZ_PATH', '..')


ext_modules = [
    Extension(
        'hfuzz.native',
        ['hfuzz/native.pyx'],
        extra_objects=[
            os.path.join(HFUZZ_PATH, 'libhfuzz/libhfuzz.a'),
            os.path.join(HFUZZ_PATH, 'libhfcommon/libhfcommon.a'),
        ],
        include_dirs=[HFUZZ_PATH],
    )
]

setup(
    name='hfuzz',
    setup_requires=['cython'],
    version='0.1',
    ext_modules=cythonize(ext_modules),
    packages=['hfuzz'],
    package_dir={
        'hfuzz': 'hfuzz',
    },
)
