import Base: mean, var

function gelman_rubin(traces)
    
    m = size(traces)[1]
    
    if m < 2:
        return "NA"
    end

    n_array = [size(a)[1] for a in traces]
    
    if size(unique(n_array))[1] != 1
        return "NA"
    else
        n = n_array[1]
    end

    dim_array = [size(a)[2] for a in traces]

    if size(unique(dim_array))[1] != 1
        return "NA"
    else
        dim = dim_array[1]
    end

    if dim > 1
        return [gelman_rubin([a[:,i] for a in traces]) for i in 1:dim]

    var_array = [var(a) for a in traces]
    mean_array = [mean(a) for a in traces]
    mean_mean = mean(mean_array)

    W = mean(var_array)
    
    B = (n * (m - 1)) * sum([(a - mean_mean) for a in mean_array])

    pVar = (1 - 1 / n) * W + (1 / n) * B

    R = sqrt(pVar / W)

    return R
