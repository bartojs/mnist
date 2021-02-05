const MB_SIZE = sizeof(UInt32)
const IMAGE_HDR_SIZE = MB_SIZE + sizeof(UInt32) * 3
const LABEL_HDR_SIZE = MB_SIZE + sizeof(UInt32)
const PIXEL_ROWS = 28
const PIXEL_COLS = 28
const IMAGE_SIZE = PIXEL_ROWS*PIXEL_COLS

function hdr(io, n)
    a = Array{UInt32,1}(undef, n)
    seek(io, 0)
    read!(io, a)
    ntoh.(Tuple(a))
end

function image(io, i)
    img = Array{UInt8,1}(undef, IMAGE_SIZE)
    seek(io, IMAGE_HDR_SIZE + IMAGE_SIZE * (i - 1))
    n = readbytes!(io, img, IMAGE_SIZE)
    @assert(n==IMAGE_SIZE, "image size mismatch")
    reshape(img, (PIXEL_ROWS,PIXEL_COLS))
end

function label(io, i)
    seek(io, LABEL_HDR_SIZE + (i - 1))
    read(io, UInt8)
end

function data(imagefile, labelfile)
    imgio = open(imagefile, "r")
    labio = open(labelfile, "r")

    mb1,count,rows,cols = hdr(imgio, 4)
    mb2,count2 = hdr(labio, 2)
    @assert(count==count2, "image and label count mismatch")
    images = Array{Float32,3}(undef, rows, cols, count)
    labels = Array{Float64,1}(undef, count)

    for i in 1:count
        images[:,:,i] = image(imgio, i)
        labels[i] = label(labio, i)
    end

    close(imgio)
    close(labio)
    (images,labels)
end
