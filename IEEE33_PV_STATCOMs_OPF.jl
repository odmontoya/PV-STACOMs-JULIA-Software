using DataFrames, LinearAlgebra
Vb = 12660; Sb = 1000; Zb = (Vb^2)/(Sb*1000);
branch_data = DataFrames.DataFrame([
(1,  2,  0.0922, 0.0477),(2,  3,  0.4930, 0.2511), 
(3,  4,  0.3660, 0.1864),(4,  5,  0.3811, 0.1941),
(5,  6,  0.8190, 0.7070),(6,  7,  0.1872, 0.6188), 
(7,  8,  1.7114, 1.2351),(8,  9,  1.0300, 0.7400), 
(9,  10, 1.0400, 0.7400),(10, 11, 0.1966, 0.0650), 
(11, 12, 0.3744, 0.1238),(12, 13, 1.4680, 1.1550), 
(13, 14, 0.5416, 0.7129),(14, 15, 0.5910, 0.5260), 
(15, 16, 0.7463, 0.5450),(16, 17, 1.2890, 1.7210), 
(17, 18, 0.7320, 0.5740),(2,  19, 0.1640, 0.1565), 
(19, 20, 1.5042, 1.3554),(20, 21, 0.4095, 0.4784), 
(21, 22, 0.7089, 0.9373),(3,  23, 0.4512, 0.3083), 
(23, 24, 0.8980, 0.7091),(24, 25, 0.8960, 0.7011), 
(6,  26, 0.2030, 0.1034),(26, 27, 0.2842, 0.1447), 
(27, 28, 1.0590, 0.9337),(28, 29, 0.8042, 0.7006), 
(29, 30, 0.5075, 0.2585),(30, 31, 0.9744, 0.9630), 
(31, 32, 0.3105, 0.3619),(32, 33, 0.3410, 0.5302), 
]);
DataFrames.rename!(branch_data, [:k, :m, :Rkm, :Xkm])
L = size(branch_data,1)
node_data = DataFrames.DataFrame([
(1,  1, 0,   0), (2,  1, 100, 60),(3,  1, 90,  40),
(4,  1, 120, 80),(5,  1, 60,  30),(6,  1, 60,  20),
(7,  1, 200, 100),(8,  1, 200, 100),(9,  1, 60,  20),
(10, 1, 60,  20),(11, 1, 45,  30),(12, 1, 60,  35),
(13, 1, 60,  35),(14, 1, 120, 80),(15, 1, 60,  10),
(16, 1, 60,  20),(17, 1, 60,  20),(18, 1, 90,  40),
(19, 1, 90,  40),(20, 1, 90,  40),(21, 1, 90,  40),
(22, 1, 90,  40),(23, 1, 90,  50),(24, 1, 420, 200),
(25, 1, 420, 200),(26, 1, 60,  25),(27, 1, 60,  25),
(28, 1, 60,  20),(29, 1, 120, 70),(30, 1, 200, 600),
(31, 1, 150, 70),(32, 1, 210, 100),(33, 1, 60,  40),]);
DataFrames.rename!(node_data, [:k, :Vk0, :Pk, :Qk])
daily_data = DataFrames.DataFrame([
(1,  0.3400, 0.2954,      0),(2,  0.2800, 0.2238,      0),
(3,  0.2200, 0.1964,      0),(4,  0.2200, 0.1666,      0),
(5,  0.2200, 0.1478,      0),(6,  0.2000, 0.1654,      0),
(7,  0.1800, 0.1662,      0),(8,  0.1800, 0.1274,      0),
(9,  0.1800, 0.1404,      0),(10, 0.2000, 0.1750,      0),
(11, 0.2200, 0.1456, 0.0003),(12, 0.2600, 0.2428, 0.0187),
(13, 0.2800, 0.2462, 0.0732),(14, 0.3400, 0.2780, 0.1611),
(15, 0.4000, 0.2820, 0.2696),(16, 0.5000, 0.3996, 0.3827),
(17, 0.6200, 0.4994, 0.4914),(18, 0.6800, 0.6448, 0.5988),
(19, 0.7200, 0.6526, 0.6938),(20, 0.7800, 0.7322, 0.7724),
(21, 0.8400, 0.7170, 0.8469),(22, 0.8600, 0.6632, 0.9049),
(23, 0.9000, 0.8374, 0.9492),(24, 0.9200, 0.7304, 0.9834),
(25, 0.9400, 0.6764, 1.0000),(26, 0.9400, 0.7228, 0.9944),
(27, 0.9000, 0.7754, 0.9765),(28, 0.8400, 0.6868, 0.9456),
(29, 0.8600, 0.7542, 0.9079),(30, 0.9000, 0.8538, 0.8508),
(31, 0.9000, 0.8448, 0.7761),(32, 0.9000, 0.7294, 0.6978),
(33, 0.9000, 0.8452, 0.6023),(34, 0.9000, 0.6162, 0.4984),
(35, 0.9000, 0.5988, 0.3894),(36, 0.9000, 0.6672, 0.2804),
(37, 0.8600, 0.7086, 0.1708),(38, 0.8400, 0.6798, 0.0796),
(39, 0.9200, 0.8468, 0.0202),(40, 1.0000, 0.8122, 0.0003),
(41, 0.9800, 0.7640,      0),(42, 0.9400, 0.7640,      0),
(43, 0.9000, 0.7774,      0),(44, 0.8400, 0.5502,      0),
(45, 0.7600, 0.6766,      0),(46, 0.6800, 0.4710,      0),
(47, 0.5800, 0.4602,      0),(48, 0.5000, 0.3636,      0),
]);
DataFrames.rename!(daily_data, [:t, :Pd, :Qd, :Gpv])
H = size(daily_data,1); Dh = 24/H;
N = size(node_data,1)
A = zeros(N,L)
for l = 1:L
    k = branch_data.k[l]; m = branch_data.m[l];
    A[k,l] = 1;  A[m,l] = -1
end
z = (branch_data.Rkm .+ im*branch_data.Xkm)/Zb
Ybus = A*inv(LinearAlgebra.diagm(z))*transpose(A)
slack = 1; Vmin = 0.90; Vmax = 1.10;
dg = [13;24;30]; Sdgmax = [800;1090;1050]/Sb; 
Sd = (node_data.Pk .+ im*node_data.Qk)/Sb;
Sgdm = zeros(N,H); Pvstm = zeros(N,H);
Sgdm[dg,:] = ones(length(dg),H).*Sdgmax;
Pvstm[dg,:] = transpose(daily_data.Gpv).*Sdgmax;
using JuMP, Ipopt
Scenario = 1; CkWh = 0.1390;
OPF = Model(Ipopt.Optimizer)
set_optimizer_attribute(OPF,"constr_viol_tol", 1e-12)
@variable(OPF,V[k in 1:N, h in 1:H] 
in ComplexPlane(),start = 1.0 + 0.0im);
@variable(OPF, Sg[k in 1:N, h in 1:H] 
in ComplexPlane());
@variable(OPF, Sdg[k in 1:N, h in 1:H] 
in ComplexPlane());
#@objective(OPF,Min,Sb*real(sum(sum(conj(V[k,h])*
#sum(Ybus[k,m]*V[m,h] 
#for m = 1:N) for k = 1:N) for h = 1:H))*Dh);
#@objective(OPF,Min,CkWh*Sb*real(sum(sum(Sg[k,h] for k = 1:N) for h = 1:H))*Dh);
@objective(OPF,Min,(100/(N*H))*sum(sum((abs2(V[k,h]) - abs2(1) for k = 1:N for h = 1:H))));
for h = 1:H
    @constraint(OPF, V[slack,h] == 1.0 + im*0.0);
    for k = 1:N
        @constraint(OPF,conj(Sg[k,h])+conj(Sdg[k,h])- 
        conj(real(Sd[k])*daily_data.Pd[h] + 
        im*imag(Sd[k])*daily_data.Qd[h]) ==
        conj(V[k,h])*sum(Ybus[k,m]*V[m,h] for m=1:N))
        @constraint(OPF, abs2(Vmin) <= abs2(V[k,h]) 
        <= abs2(Vmax));
        if k != slack 
            @constraint(OPF, Sg[k,h] == 0);
        else
            @constraint(OPF, real(Sg[k,h]) >= 0);
        end
        if Scenario == 0
            @constraint(OPF, real(Sdg[k,h]) == 0);
            @constraint(OPF, imag(Sdg[k,h]) == 0);
        elseif Scenario == 1
            @constraint(OPF, real(Sdg[k,h]) == 0);
            @constraint(OPF, abs2(Sdg[k,h]) <=
            abs2(Sgdm[k,h]));
        elseif Scenario == 2
            @constraint(OPF, 0 <= real(Sdg[k,h]) <=
            Pvstm[k,h]);
            @constraint(OPF, abs2(Sdg[k,h]) <=
            abs2(Sgdm[k,h]));
            @constraint(OPF, imag(Sdg[k,h]) == 0);
        else
            @constraint(OPF, 0 <= real(Sdg[k,h]) <=
            Pvstm[k,h]);
            @constraint(OPF, abs2(Sdg[k,h]) <=
            abs2(Sgdm[k,h]));
        end
end
end
JuMP.optimize!(OPF)
@show objective_value(OPF);

