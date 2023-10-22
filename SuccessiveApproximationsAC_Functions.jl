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
epsilon = 1e-10; tmax = 1000;
function SAPF(node_data,Ybus,epsilon,tmax,Sb)
Ydd = Ybus[2:end,2:end]; Zdd = inv(Ydd);
Yds = Ybus[2:end,1];
Vs = node_data.Vk0[1,1];
Vd = node_data.Vk0[2:N,1];
Sd = (node_data.Pk[2:N,1]+im*node_data.Qk[2:N,1])/Sb
Vx = [Vs;Vd];
for t = 1:tmax
   Vdt = -Zdd*(inv(LinearAlgebra.diagm(conj(Vd)))*
               conj(Sd) + Yds*Vs)
   if maximum(abs.(abs.(Vd) - abs.(Vdt))) < epsilon
    Vx = [Vs;Vdt]
    break
   else
    Vd = Vdt;
   end
end
return Vx
end
Vx = SAPF(node_data,Ybus,epsilon,tmax,Sb)
Sloss = transpose(Vx)*conj!(Ybus*Vx)*Sb
Report = DataFrames.DataFrame(;Bus = 1:N,
VoltageMagnitude = abs.(Vx),
VoltageAngle_Deg =rad2deg.(angle.(Vx)),)