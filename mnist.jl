    const IMAGEOFFSET = 16
    const LABELOFFSET = 8

    const NROWS = 28
    const NCOLS = 28

    const TRAINIMAGES = joinpath(
        dirname(@__FILE__), "train-images-idx3-ubyte"
    )
    const TRAINLABELS = joinpath(
        dirname(@__FILE__), "train-labels-idx1-ubyte"
    )
    const TESTIMAGES = joinpath(
        dirname(@__FILE__), "t10k-images-idx3-ubyte"
    )
    const TESTLABELS = joinpath(
        dirname(@__FILE__), "t10k-labels-idx1-ubyte"
    )

    function imageheader(filename::AbstractString)
        io = open(filename, "r")
        magic_number = bswap(read(io, UInt32))
        total_items = bswap(read(io, UInt32))
        nrows = bswap(read(io, UInt32))
        ncols = bswap(read(io, UInt32))
        close(io)
        return (
            magic_number,
            Int(total_items),
            Int(nrows),
            Int(ncols)
        )
    end

    function labelheader(filename::AbstractString)
        io = open(filename, "r")
        magic_number = bswap(read(io, UInt32))
        total_items = bswap(read(io, UInt32))
        close(io)
        return magic_number, Int(total_items)
    end

    function getimage(filename::AbstractString, index::Integer)
        io = open(filename, "r")
        seek(io, IMAGEOFFSET + NROWS * NCOLS * (index - 1))
        #image_t = read(io, UInt8, (NROWS, NCOLS))

        image_t = Array{UInt8,1}(undef, NROWS*NCOLS);
        readbytes!(io, image_t);
        close(io)
        #return image_t'
        return image_t
    end

    function getlabel(filename::AbstractString, index::Integer)
        io = open(filename, "r")
        seek(io, LABELOFFSET + (index - 1))
        label = read(io, UInt8)
        close(io)
        return label
    end

    function trainimage(index::Integer)
        convert(Array{Float64}, getimage(TRAINIMAGES, index))
    end

    function testimage(index::Integer)
        convert(Array{Float64}, getimage(TESTIMAGES, index))
    end

    function trainlabel(index::Integer)
        convert(Float64, getlabel(TRAINLABELS, index))
    end

    function testlabel(index::Integer)
        convert(Float64, getlabel(TESTLABELS, index))
    end

    trainfeatures(index::Integer) = vec(trainimage(index))

    testfeatures(index::Integer) = vec(testimage(index))

    function traindata()
        _, nimages, nrows, ncols = imageheader(TRAINIMAGES)
        nimages = 3
        #features = Array(Float64, nrows * ncols, nimages)
        #labels = Array(Float64, nimages)
        features = Array{Float64,2}(undef, nimages, nrows * ncols)
        labels = Array{Float64,1}(undef, nimages)
        for index in 1:nimages
            features[index,:] = trainfeatures(index)
            labels[index] = trainlabel(index)
        end
        return features, labels
    end

    function testdata()
        _, nimages, nrows, ncols = imageheader(TESTIMAGES)
        features = Array(Float64, nrows * ncols, nimages)
        labels = Array(Float64, nimages)
        for index in 1:nimages
            features[:, index] = testfeatures(index)
            labels[index] = testlabel(index)
        end
        return features, labels
    end

show(traindata())
