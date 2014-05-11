import Base: mean, std

function gen_zscore(chain, intervals, f, l)

    zscores = cell(intervals)
    e = size(chain)[1]
    
    stp = (l - f) / intervals
    
    for i = 1:intervals
        f_ind = int((f + (i - 1) * stp) * e)
        l_ind = int((f + i * stp) * e)
        f_chunk = chain[f_ind: l_ind]
        l_chunk = chain[l_ind:]
        z = mean(f_chunk) - mean(l_chunk)
        z = z / sqrt(std(f_chunk)^2 + std(l_chunk)^2)
        zscores[i] = z
    end

    return zscores
end


function geweke(chain, intervals, f, l)
    
    dim = size(chain)[2]
    
    if dim > 1
        return [gen_zscore(chain[:,i], intervals, f, l) for i=1:dim]
    else
        return gen_zscore(chain, intervals, f, l)
    end
end
