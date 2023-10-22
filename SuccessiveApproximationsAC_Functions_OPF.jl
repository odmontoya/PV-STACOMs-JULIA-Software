# Successive approximation power flow single-phase grids
import DataFrames
import LinearAlgebra
# System bases
Vb = 23000; # V
Sb = 1000; # kVA
Zb = (Vb^2)/(Sb*1000);
# System information Data in Ohm
branch_data = DataFrames.DataFrame([
    (1, 2, 0.5025, 0.3025),
    (2, 3, 0.4020, 0.2510),
    (3, 4, 0.3660, 0.1864),
    (2, 5, 0.3840, 0.1965),
    (5, 6, 0.8190, 0.7050),
    (2, 7, 0.2872, 0.4088),
]);
DataFrames.rename!(branch_data, [:k, :m, :Rkm, :Xkm])
L = size(branch_data,1)
# System information Data in kVA
node_data = DataFrames.DataFrame([
    (1, 1, 0, 0),
    (2, 1, 1000, 600),
    (3, 1, 900,  500),
    (4, 1, 2500, 1200),
    (5, 1, 1200, 950),
    (6, 1, 1050, 780),
    (7, 1, 2000, 1150),
]);
DataFrames.rename!(node_data, [:k, :Vk0, :Pk, :Qk])
N = size(node_data,1)
L = size(branch_data, 1)
A = zeros(N,L)
for l = 1:L
    k = branch_data.k[l]; m = branch_data.m[l];
    A[k,l] = 1
    A[m,l] = -1
end
z = (branch_data.Rkm .+ im*branch_data.Xkm)/Zb
Ybus = A*inv(LinearAlgebra.diagm(z))*transpose(A)
# Iterative formula
using JuMP, Ipopt
slack = 1;
dg = 3; Sdgmax = 7500/Sb; Vmin = 0.90; Vmax = 1.10;
Sd = (node_data.Pk .+ im*node_data.Qk)/Sb;
OPF = Model(Ipopt.Optimizer);
@variable(OPF,V[k in 1:N] in ComplexPlane(),
start = 1.0 + 0.0im);
@constraint(OPF, V[slack] == 1.0 + im*0.0);
@variable(OPF, Sg[k in 1:N] in ComplexPlane());
@variable(OPF, Sdg[k in 1:N] in ComplexPlane());
@objective(OPF,Min,Sb*real(sum(conj(V[k])*
sum(Ybus[k,m]*V[m] for m = 1:N) for k = 1:N)));
for k = 1:N
    @constraint(OPF,conj(Sg[k]) + conj(Sdg[k]) - 
    conj(Sd[k]) ==
    conj(V[k])*sum(Ybus[k,m]*V[m] for m = 1:N));
    @constraint(OPF, abs2(Vmin) <= abs2(V[k]) 
    <= abs2(Vmax));
    if k != slack 
        @constraint(OPF, Sg[k] == 0);
    end
    if k != dg
        @constraint(OPF, Sdg[k] == 0);
    else
        @constraint(OPF, abs2(Sdg[k]) <= abs2(Sdgmax));
        @constraint(OPF, imag(Sdg[k]) == 0);
    end
end
JuMP.optimize!(OPF)
@show objective_value(OPF); value.(V)

