include("mnist.jl")

training() = data("train-images-idx3-ubyte","train-labels-idx1-ubyte")
testing() = data("t10k-images-idx3-ubyte","t10k-labels-idx1-ubyte")


function showimage(m)
    for row in 1:PIXEL_ROWS
        for col in 1:PIXEL_COLS
            print(m[col,row] == 0 ? " " : "#")
        end
        println()
    end
end

using Knet

x,y = testing()

dtst = minibatch(x,y,100)

for i in 1:5
    showimage(x[:,:,i])
    show(y[i])
end


function linear(w, x)
   weight,bias = w
   y = weight * mat(x) .+ bias
end


