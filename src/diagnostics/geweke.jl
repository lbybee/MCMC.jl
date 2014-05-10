import Base: mean, std

function geweke(chain, intervals, f, l)
    
    dim = size(chain)[2]
    
    if dim > 1
        return [geweke(c, intervals, f, l) for c in chain]
    end   

    zscores = cell(intervals)
    
    e = size(chain[1])
    
    stp = (l - f) / intervals
    
    for i = 1:intervals
        f_ind = ((f + (i - 1) * stp) * e)
        l_ind = ((f + i * stp) * e)
        f_chunk = chain[f_ind: l_ind]
        l_chunk = chain[l_ind:]
        z = mean(f_chunk) - mean(l_chunk)
        z = z / sqrt(std(f_chunk)^2 + std(l_chunk)^2)
        zscores[i] = z
    end

    return zscores
end
