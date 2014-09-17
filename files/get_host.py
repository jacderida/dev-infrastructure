import sys
from urlparse import urlparse

uri = sys.argv[1]
result = urlparse(uri)
print result.hostname
