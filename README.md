# Python HFuzz

Everything you need to glue
[honggfuzz](https://github.com/google/honggfuzz)
and python 3.

## Install

```sh
cd /path/to/honggfuzz/sources/
git clone https://github.com/thebabush/python-hfuzz.git python
cd python
python setup.py install
```

**Important:** do not use `pip`. Right now I'm using relative paths to link
honggfuzz' static libraries to python-hfuzz and `pip` doesn't like that.
Feel free to create a PR to improve the build system.

## Usage

Normal execution:

```sh
honggfuzz -f ./corpus -F 8 -- ./examples/cmp.py ___FILE___
```

Persistent mode:

```sh
honggfuzz -f ./corpus -F 8 -P -- ./examples/persistent.py
```

## Why?

Well, the main reasons are these:

1. There are [DBIs](https://github.com/QBDI/QBDI) out there that can be scripted
   in python.
   While it's not the best idea performance-wise, sometimes your
   dev-speed/run-speed trade-off makes it worth it in the short term
   (e.g.: one-off custom feedback implementations, research, CTFs, etc...)
2. Fuzzing python programs. Coupled with some nice bytecode-level
   instrumentation, this could be interesting.

