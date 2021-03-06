export ess, actime

# Effective sample size (ESS)
actypes = (:bm, :imse, :ipse)

function ess(x::Vector{Float64}; vtype::Symbol=:imse, args...)
  @assert in(vtype, actypes) "Unknown ESS type $vtype"

  return length(x)*mcvar(x; vtype=:iid)/mcvar(x; vtype=vtype, args...)
end

ess(x::Matrix{Float64}, pars::Ranges=1:size(x, 2); vtype::Symbol=:imse, args...) =
  Float64[ess(x[:, pars[i]]; vtype=vtype, args...) for i = 1:pars.len]

ess(x::Matrix{Float64}, par::Real; vtype::Symbol=:imse, args...) = ess(x, par:par; vtype=vtype, args...)

ess(c::MCMCChain, pars::Ranges=1:size(c.samples, 2); vtype::Symbol=:imse, args...) =
  ess(c.samples, pars; vtype=vtype, args...)

ess(c::MCMCChain, par::Real; vtype::Symbol=:imse, args...) = ess(c, par:par; vtype=vtype, args...)

# Integrated autocorrelation time
function actime(x::Vector{Float64}; vtype::Symbol=:imse, args...)
  @assert in(vtype, actypes) "Unknown actime type $vtype"

  return mcvar(x; vtype=vtype, args...)/mcvar(x; vtype=:iid)
end

actime(x::Matrix{Float64}, pars::Ranges=1:size(x, 2); vtype::Symbol=:imse, args...) =
  Float64[actime(x[:, pars[i]]; vtype=vtype, args...) for i = 1:pars.len]

actime(x::Matrix{Float64}, par::Real; vtype::Symbol=:imse, args...) = actime(x, par:par; vtype=vtype, args...)

actime(c::MCMCChain, pars::Ranges=1:size(c.samples, 2); vtype::Symbol=:imse, args...) =
  actime(c.samples, pars; vtype=vtype, args...)

actime(c::MCMCChain, par::Real; vtype::Symbol=:imse, args...) = actime(c, par:par; vtype=vtype, args...)
