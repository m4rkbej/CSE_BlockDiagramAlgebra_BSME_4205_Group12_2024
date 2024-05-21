%Clear
clear
clc
close all

%% Define G1, G2, G3, H1, H2 and H3

G1_num = [0 0 1];
G1_den = [1 0 0];
G1 = tf(G1_num,G1_den)

G2_num = [0 0 1];
G2_den = [1 1];
G2 = tf(G2_num,G2_den)

G3_num = [0 1];
G3_den = [1 0];
G3 = tf(G3_num,G3_den)

H1_num = [0 1];
H1_den = [1 0];
H1 = tf(H1_num,H1_den)

H2_num = [0 1];
H2_den = [1 -1];
H2 = tf(H2_num,H2_den)

H3_num = [0 1];
H3_den = [1 -2];
H3 = tf(H3_num,H3_den)

%% Block Diagram Reduction 
%For G2 and H2
GH2_num = conv(G2_num,H2_num);
GH2_den = conv(G2_den,H2_den);
GH2 = tf(GH2_num, GH2_den)

Tf2_num = conv(G2_num,GH2_den)
Tf2_den_add = GH2_den + [0 0 1]
Tf2_den = conv(Tf2_den_add, G2_den)
TF2 = tf(Tf2_num,Tf2_den)

%For 1/G2 branch
G2_branch_num = [1]
G2_num_line = [1]
TF_G2_branch = [G2_branch_num / G2] + G2_num_line
Branch_G2_num = TF_G2_branch

%For G3 and H3
GH3_num = conv(G3_num,H3_num);
GH3_den = conv(G3_den,H3_den);

Tf3_num = conv(G3_num,GH3_den)
Tf3_den_add = GH3_den+ GH3_num;
Tf3_den = conv(G3_den,Tf3_den_add)
TF3 = tf(Tf3_num,Tf3_den)

%For G3, H3 and 1/G2 branch
TF_G3H3branchG2_num = [1 0 -4 0]
TF_G3H3branchG2_den = Tf3_den
TF_G3H3branchG2 = tf(TF_G3H3branchG2_num, TF_G3H3branchG2_den)

%For G1 and G2H2
TFG1G2H2_num = conv(G1_num, Tf2_num)
TFG1G2H2_den= conv(G1_den, Tf2_den)
TF_G1G2H2= tf(TFG1G2H2_num, TFG1G2H2_den)

%For G1G2H2 and H1
G1G2H2H1_num = conv(TFG1G2H2_num, H1_num)
G1G2H2H1_den = conv(TFG1G2H2_den, H1_den)
G1G2H2H1 = tf(G1G2H2H1_num,G1G2H2H1_den)

%For denominator
TF_G1G2H2H1_den_add = G1G2H2H1_den + TFG1G2H2_num
TF_G1G2H2H1_den = conv(TF_G1G2H2H1_den_add,TFG1G2H2_den)
TF_G1G2H2H1_num = conv(TFG1G2H2_num,G1G2H2H1_den)
TF_G1G2H2H1= tf(TF_G1G2H2H1_num,TF_G1G2H2H1_den)

%For TF_G1G2H2H1 and TF_G3H3branchG2 
S_num = [1 1 -1 -1 0 0 0 0 0]
S_den = [1 2 1 0 1 1 -1 -1 0 0 0 0]

R_num = [1 0 -4 0]
R_den = [1 -2 1 0]

%Final Reduced Block Diagram, 
TF_Final_num = conv(S_num,R_num)
TF_Final_den = conv(S_den,R_den)
TF_Final = tf(TF_Final_num, TF_Final_den)

%Step Response
step(TF_Final,0:0.1:20)









