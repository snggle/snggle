#!/usr/bin/python3 -u
import sys
from distutils.version import StrictVersion

DEV_BRANCH_VERSION=sys.argv[1]
WORKING_BRANCH_VERSION=sys.argv[2]

RESULT=StrictVersion(WORKING_BRANCH_VERSION) > StrictVersion(DEV_BRANCH_VERSION)
print(RESULT)