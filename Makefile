setup:
	julia -e 'import Pkg; Pkg.add("Printf"); Pkg.add("Knet");'

data:
	for x in train-images-idx3-ubyte.gz train-labels-idx1-ubyte.gz t10k-images-idx3-ubyte.gz t10k-labels-idx1-ubyte.gz; do curl -o $$x http://yann.lecun.com/exdb/mnist/$$x; gunzip $$x; done

run:
	julia test.jl
