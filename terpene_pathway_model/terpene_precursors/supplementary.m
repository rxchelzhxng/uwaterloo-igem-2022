function xdot = mint_MEP6_GH_WT(t,x) 

% This function calculates monoterpene amounts (40 day time course) in leaves 
% of peppermint WT plants grown in a greenhouse with supplemental lighting from sodium 
% vapor lights.
% A mechanism following regular Michaelis-Menten-type kinetics is assumed for all 
% enzymes with the following exceptions:
% (1)  Substrate inhibition of (+)-pulegone reductase 
% (2)  Competitive inhibition of (+)-pulegone reductase by (+)-menthofuran
% (3)  Competitive inhibition of isopentenyl-diphosphate isomerase by GPP
% (4)  Reversible reaction mechanisms were assume for 1-Deoxy-D-xylulose-5-phosphate 
%      reductoisomerase and (-)-Menthone:(+)-neomenthol reductase
% (5)  Bi-bi (two substrates, two products) reaction mechanisms were assumed for 
%      1-deoxy-D-xylulose-5-phosphate synthase (Pyruvate + GAP = DXP + Co2) and geranyl 
%      diphosphate synthase (IPP + DMAPP = GPP + PPi).  The former utilizes an ordered mechanism 
%     (Pyr binds first), whereas a random mechanism is assumed for the latter.


% Metabolite Nomenclature

%[GAP]=x(1)          D-Glyceraldehyde 3-Phosphate
%[Pyr]=x(2)          Pyruvate
%[DOXP]=x(3)         1-Deoxy-D-xylulose 5-phosphate
%[ME4P]=x(4)         2-C-Methyl-D-erythritol-4-phosphate
%[CDPME]=x(5)        4-(Cytidine 5'-diphospho)-2-C-methyl-D-erythritol
%[CDPME2P]=x(6)      2-Phospho-4-(cytidine 5'-diphospho)-2-C-methyl-D-erythritol
%[MEcPP]=x(7)        2-C-Methyl-D-erythritol-2,4-cyclodiphosphate
%[HMBPP]=x(8)        1-Hydroxy-2-methyl-2-(E)-butenyl 4-diphosphate
%[DMAPP]=x(9)        Dimethylallyl-pyrophosphate
%[IPP]=x(10)         Isopentenyl diphosphate
%[GPP]=x(11)         Geranyl diphosphate
%[LIM]=x(12)         (-)-Limonene
%[IPPol]=x(13)       (-)-trans-Isopiperitenol
%[IPPone]=x(14)      (-)-Isopiperitenone
%[CIPUL]=x(15)       (+)-cis-Isopulegone
%[PUL]=x(16)         (+)-Pulegone
%[MF]=x(17)          (+)-Menthofuran
%[IMone]=x(18)       (+)-Isomenthone
%[Mone]=x(19)        (-)-Menthone 
%[NMol]=x(20)        (+)-Neomenthol
%[Mol]=x(21)         (-)-Menthol
%[IMol]=x(22)        (+)-Isomenthol
%[NIMol]=x(23)       (+)-Neoisomenthol

% Kinetic Parameters 

% kc units: [1/s]    (kc = Kcat)
% KM units: [uM]
% Ki units: [uM]

 KM1a = 68;     %1-Deoxy-D-xylulose-5-phosphate synthase (DXS) for GAP 
 kc1a = 1.9; 
 KM1b = 440;    %1-Deoxy-D-xylulose-5-phosphate synthase (DXS) for Pyr
 kc1b = 1.9;
 Kia = 16;      %Dissociation constant for Pyr
 KM2f = 132;    %1-Deoxy-D-xylulose-5-phosphate reductoisomerase (DXR; forward reaction) 
 kc2f = 4.4;
 KM2r = 972;    %1-Deoxy-D-xylulose-5-phosphate reductoisomerase (DXR; reverse reaction) 
 kc2r = 1.6;
 KM3 = 500;     %2-C-Methyl-D-erythritol 4-phosphate cytidylyltransferase (MCT)
 kc3 = 26; 
 KM4 = 100;     %4-(Cytidine 5'-diphospho)-2-C-methyl-D-erythritol kinase (CMK)    
 kc4 = 1;
 KM5 = 252;     %2-C-Methyl-D-erythritol 2,4-cyclodiphosphate synthase (MECPS)
 kc5 = 3.4; 
 KM6 = 420;     %4-Hydroxy-3-methylbut-2-en-1-yl diphosphate synthase (HDS)
 kc6 = 0.4;
 KM7 = 30;      %4-Hydroxy-3-methylbut-2-en-1-yl diphosphate reductase (HDR)
 kc7 = 3.7;
 KM8f = 5.1;    %Isopentenyl-diphosphate delta-isomerase for IPP (IPPI; forward reaction)
 kc8f =0.018;
 KM8r = 17;     %Isopentenyl-diphosphate delta-isomerase for DMAPP (IPPI; rev reaction)
 kc8r = 0.89;
 KM9a = 54;     %Geranyl diphosphate synthase (GPPS; DMAPP as substrate)
 kc9a = 48;
 KM9b = 26;     %Geranyl diphosphate synthase (GPPS; IPP as substrate)
 kc9b = 48;
 KM10 = 20;     %(-)-Limonene synthase (LS)
 kc10 = 0.3;
 KM11 = 18;     %(-)-Limonene 3-hyroxylase (L3H)
 kc11 = 1.8; 
 KM12 = 72;     %(-)-trans-Isopiperitenol dehydrogenase (IsoDH)
 kc12 = 0.002;
 KM13 = 1;      %(-)-Isopiperitenone reductase (IsoR)
 kc13 = 1.3;
 KM14 = 270;    %(+)-cis-Isopulegone isomerase (IsoI)
 kc14 = 2.5;
 KM15 = 30;     %(+)-Menthofuran synthase (MFS)
 kc15 = 2.0; 
 KM16a = 2.3;   %(+)-Pulegone reductase (PR; product: (-)-menthone)
 kc16a = 1.8; 
 KM16b = 2.3;   %(+)-Pulegone reductase (PR; product: (+)-isomenthone)
 kc16b = 1.8; 
 KM17a = 3;     %(-)-Menthone:(-)-menthol reductase (MMR; substrate: (-)-menthone) 
 kc17a = 0.6; 
 KM17b = 41;    %(-)-Menthone:(-)-menthol reductase (MMR; substrate: (+)-isomenthone)
 kc17b = 0.6;
 KM18af  = 674; %(-)-Menthone:(+)-neomenthol reductase (MNR; substrate: (-)-menthone); 
%                      forward reaction)
 kc18af = 0.06;
 KM18ar = 1200; %(-)-Menthone:(+)-neomenthol reductase (MNR; substrate: (-)-menthone); 
%                      backward reaction)
 kc18ar  = 0.06;% estimated
 KM18b = 1000;  %(-)-Menthone:(+)-neomenthol reductase (MNR; substrate: (+)-isomenthone)
 kc18b = 0.06;
 
Kic1=96;        % Product inhibition constant (Geranyl diphosphate acting on IPPI)
Kic2=300;       % Product inhibition constant ((+)-menthofuran acting on PR)
                % Competitive inhibition mechanism

Kis=112;        % Substrate Inhibition constant ((+)-pulegone acting on PR)
                % Uncompetitive inhibition mechanism

z=100;          % Factor to account for the actual concentration of (+)-menthofuran in 
%                   secretory cells of glandular trichomes

w=0.05;         % Factor to account for the actual concentration of (+)-pulegone in
%                   secretory cells of glandular trichomes


% The model also takes into account that each enzyme shows a particular transient  
% pattern of expression.  This pattern is approximated by a Gauss function.  

%First peak of activity:

%f(x) = Comp * a * exp((-(t-b).^2)/(2*(c)^2))

%where   Comp = Factor to adjust for the volume density of the compartment in which a 
%                 particular enzyme is active [Dimensionless]
%        a    = Factor defining the height of the Gaussian peak for enzyme activity
%                 [µM]
%        t    = Time [s]
%        b    = Factor defining the position of the center of the Gaussian peak for
%                 enzyme activity [s]
%        c    = Factor defining the width of the Gaussian peak for enzyme activity at
%                 half maximum [s]

b1=1296000;   % Defines the position of the center of the Gaussian peak for enzyme
%                 activity.
              % Relevant to the following enzyme activities: LS, L3H, IsoDH, IsoR, IsoI, 
%                 MFS, PR
c1=800000;    % Defines the width of the Gaussian peak for enzyme activity at half 
%                 maximum.    
              % Relevant to the following enzyme activities: LS, L3H, IsoDH, IsoR, IsoI, 
%                 MFS, PR
  
b5=1800000;   % Defines the position of the center of the Gaussian peak for enzyme 
%                 activity.
              % Relevant to the following enzyme activities: MMR, MNR

c5=900000;    % Defines the width of the Gaussian peak for enzyme activity at half
%                 maximum.     
              % Relevant to the following enzyme activities: MMR, MNR                       
                         
E1=(0.139)*0.03*exp((-(t-b1).^2)/(2*(c1)^2));       % DXS
E2=(0.139)*0.0225*exp((-(t-b1).^2)/(2*(c1)^2));     % DXR
E3=(0.139)*0.5*exp((-(t-b1).^2)/(2*(c1)^2));        % MCT 
E4=(0.139)*0.0225*exp((-(t-b1).^2)/(2*(c1)^2));     % CMK 
E5=(0.139)*0.5*exp((-(t-b1).^2)/(2*(c1)^2));        % MECPS 
E6=(0.139)*0.5*exp((-(t-b1).^2)/(2*(c1)^2));        % HDS  
E7a=(0.139)*0.2*exp((-(t-b1).^2)/(2*(c1)^2));       % HDR (product: DMAPP)
E7b=(0.139)*0.04*exp((-(t-b1).^2)/(2*(c1)^2));      % HDR (product: IPP)
E8=(0.139)*0.3*exp((-(t-b1).^2)/(2*(c1)^2));        % IPPI 
E9=(0.139)*0.1*exp((-(t-b1).^2)/(2*(c1)^2));        % GPPS
E10= (0.139)*0.017*exp((-(t-b1).^2)/(2*(c1)^2));    % LS    
E11= (0.365)*0.003*exp((-(t-b1).^2)/(2*(c1)^2));    % L3H 
E12= (0.044)*10*exp((-(t-b1).^2)/(2*(c1)^2));       % IsoDH  
E13= (0.204)*0.34*exp((-(t-b1).^2)/((2*c1)^2));     % IsoR  
E14= (0.204)*0.34*exp((-(t-b1).^2)/((2*c1)^2));     % IsoI  
E15= (0.365)*0.00007*exp((-(t-b1).^2)/(2*(c1)^2));  % MFS  
E16a=(0.204)*0.0015*exp((-(t-b1).^2)/(2*(c1)^2));   % PR  (product: (-)-menthone)
E16b=(0.204)*0.00015*exp((-(t-b1).^2)/(2*(c1)^2));  % PR  (product: (+)-isomenthone)
E17a=(0.204)*0.0011*exp((-(t-b5).^2)/(2*(c5)^2));   % MMR (product: (-)-menthol)
E17b=(0.204)*0.0011*exp((-(t-b5).^2)/(2*(c5)^2));   % MMR (product: (+)-neoisomenthol)
E18a=(0.204)*0.00001*exp((-(t-b5).^2)/(2*(c5)^2));  % MNR (product: (+)-neomenthol)
E18b=(0.204)*0.00001*exp((-(t-b5).^2)/(2*(c5)^2));  % MNR (product: (+)-isomenthol)


% The model also takes into account that the glandular trichome density (GN) changes over time.  This behavior is approximated using a logistic function:

c=5*10^5;    %  parameter approximating slope of exponential phase of sigmoid curve
k=1/8*10^4;  %  parameter approximating shape of sigmoid curve

GN = 1+ 1/(1+c*exp(-k*t)); % at day 15, gland number is 86.7 % of total gland number at
%                              day 30


%Species Equations

 if t< 1296000  % (patterns of enzymes from 0 to 15 days after leaf initiation)   


xdot=[GN*(-(kc1b*E1*x(2)*x(1)/(Kia*KM1b+KM1a*x(2)+KM1b*x(1)+x(1)*x(2)))); % Variation of GAP
     GN*(-(kc1b*E1*x(2)*x(1)/(Kia*KM1b+KM1a*x(2)+KM1b*x(1)+x(1)*x(2))));  % Variation of Pyruvate (same expression as for GAP)     GN*((kc1b*E1*x(2)*x(1)/(Kia*KM1b+KM1a*x(2)+KM1b*x(1)+x(1)*x(2)))-((KM2r*kc2f*E2*x(3)-KM2f*kc2r*E2*x(4))/(KM2f*KM2r+KM2r*x(3)+KM2f*x(4))));  % Variation of DOXP
     GN*(((KM2r*kc2f*E2*x(3)-KM2f*kc2r*E2*x(4))/(KM2f*KM2r+KM2r*x(3)+KM2f*x(4)))-(kc3*E3*x(4)/(x(4)+KM3)));        % Variation of ME4P   
     GN*((kc3*E3*x(4)/(x(4)+KM3))-(kc4*E4*x(5)/(x(5)+KM4)));        % Variation of CDP-ME
     GN*((kc4*E4*x(5)/(x(5)+KM4))-(kc5*E5*x(6)/(x(6)+KM5)));        % Variation of CDP-ME2P
     GN*((kc5*E5*x(6)/(x(6)+KM5))-(kc6*E6*x(7)/(x(7)+KM6)));        % Variation of MEcPP
     GN*((kc6*E6*x(7)/(x(7)+KM6))-(kc7*E7a*x(8)/(x(8)+KM7))- (kc7*E7b*x(8)/(x(8)+KM7))); % Variation of HMB-PP
     GN*((kc7*E7a*x(8)/(x(8)+KM7))+(kc8f*E8*x(10)/(x(10)+KM8f*(1+(x(11)/Kic1))))-(kc8r*E8*x(9)/(x(9)+KM8r*(1+(x(11)/Kic1))))-((kc9a*E9*KM9b*x(9)+kc9b*E9*KM9a*x(10))/(KM9b*x(9)+KM9a*x(10)+KM9a*KM9b))); %Variation of DMAPP  
     GN*((kc7*E7b*x(8)/(x(8)+KM7))+(kc8r*E8*x(9)/(x(9)+KM8r*(1+(x(11)/Kic1))))-(kc8f*E8*x(10)/(x(10)+KM8f*(1+(x(11)/Kic1))))-((kc9a*E9*KM9b*x(9)+kc9b*E9*KM9a*x(10))/(KM9b*x(9)+KM9a*x(10)+KM9a*KM9b))); %Variation of IPP 
     GN*(((kc9a*E9*KM9b*x(9)+kc9b*E9*KM9a*x(10))/(KM9b*x(9)+KM9a*x(10)+KM9a*KM9b))- (kc10*E10*x(11)/(x(11)+KM10))); %Variation of GPP     
     GN*((kc10*E10*x(11)/(x(11)+KM10))-(kc11*E11*x(12)/(x(12)+KM11))); % Variation of LIM
     GN*((kc11*E11*x(12)/(x(12)+KM11))-(kc12*E12*x(13)/(x(13)+KM12))); % Variation of IPPol
     GN*((kc12*E12*x(13)/(x(13)+KM12))-(kc13*E13*x(14)/(x(14)+KM13))); % Variation of IPPone
     GN*((kc13*E13*x(14)/(x(14)+KM13))-(kc14*E14*x(15)/(x(15)+KM14))); % Variation of CIPUL
     GN*((kc14*E14*x(15)/(x(15)+KM14))-(kc16a*E16a*x(16)/(x(16)+KM16a*(1+z*(x(17))/Kic2)))-(kc16b*E16b*x(16)/(x(16)+KM16b*(1+z*(x(17))/Kic2)))-(w*kc16a*E16a*x(16)/(KM16a+x(16)*(1+x(16)/Kis)))-(w*kc16b*E16b*x(16)/(KM16b+x(16)*(1+x(16)/Kis)))-(kc15*E15*x(16)/(x(16)+KM15))); % Variation of PUL
     GN*(kc15*E15*x(16)/(x(16)+KM15));                                % Variation of MF
     GN*((kc16b*E16b*x(16)/(x(16)+KM16b*(1+z*(x(17))/Kic2)))+(w*kc16b*E16b*x(16)/(KM16b+x(16)*(1+x(16)/Kis)))-(kc17b*E17b*x(18)/(x(18)+KM17b))-(kc18b*E18b*x(18)/(x(18)+KM18b))); % Variation of IMone
     GN*((kc16a*E16a*x(16)/(x(16)+KM16a*(1+z*(x(17))/Kic2)))+(w*kc16a*E16a*x(16)/(KM16a+x(16)*(1+x(16)/Kis)))-((KM18ar*kc18af*E18a*x(19)-KM18af*kc18ar*E18a*x(20))/(KM18af*KM18ar+KM18ar*x(19)+KM18af*x(20)))-(kc17a*E17a*x(19)/(x(19)+KM17a))); % Variation of Mone
     GN*((KM18ar*kc18af*E18a*x(19)-KM18af*kc18ar*E18a*x(20))/(KM18af*KM18ar+KM18ar*x(19)+KM18af*x(20))); % Variation of NMol
     GN*(kc17a*E17a*x(19)/(x(19)+KM17a));                             % Variation of Mol
     GN*(kc18b*E18b*x(18)/(x(18)+KM18b));                             % Variation of IMol
     GN*(kc17b*E17b*x(18)/(x(18)+KM17b))];                            % Variation of NIMol
      

else  t>= 1296000  %(patterns of enzymes from 15 - 40 days after leaf initiation)

% Second peak of enzyme activity:

  b2=1814400;   % Defines the position of the center of the second Gaussian peak for 
%                   enzyme activity. 
                % Relevant to the following enzyme activities: PR
  c2=1420000;   % Defines the width of the second Gaussian peak for enzyme activity at  half maximum.    
                % Relevant to the following enzyme activities: PR

  b4=2160000;   % Defines the position of the center of the second Gaussian peak for  enzyme activity. 
                % Relevant to the following enzyme activities: IsoDH, IsoR, IsoI
  c4=170000;    % Defines the width of the second Gaussian peak for enzyme activity at 
%                   half maximum.    
                % Relevant to the following enzyme activities: IsoDH, IsoR, IsoI

E12=(0.044)*1*exp((-(t-b4).^2)/(2*(c4)^2));             % IsoDH    
E13=(0.204)*0.0044*exp((-(t-b2).^2)/(2*(c2)^2));        % IsoR
E14=(0.204)*0.0044*exp((-(t-b2).^2)/(2*(c2)^2));        % IsoI
E16a=(0.204)*0.00014*exp((-(t-b2).^2)/(2*(c2)^2));      % PR (product: (-)-menthone)
E16b=(0.204)*0.000014*exp((-(t-b2).^2)/(2*(c2)^2));     % PR (product: (+)-isomenthone)


xdot=[GN*(-(kc1b*E1*x(2)*x(1)/(Kia*KM1b+KM1a*x(2)+KM1b*x(1)+x(1)*x(2))));  % Variation of GAP   
     GN*(-(kc1b*E1*x(2)*x(1)/(Kia*KM1b+KM1a*x(2)+KM1b*x(1)+x(1)*x(2))));   % Variation of Pyruvate (same expression as for GAP)     GN*((kc1b*E1*x(2)*x(1)/(Kia*KM1b+KM1a*x(2)+KM1b*x(1)+x(1)*x(2)))-((KM2r*kc2f*E2*x(3)-KM2f*kc2r*E2*x(4))/(KM2f*KM2r+KM2r*x(3)+KM2f*x(4))));  % Variation of DOXP
     GN*(((KM2r*kc2f*E2*x(3)-KM2f*kc2r*E2*x(4))/(KM2f*KM2r+KM2r*x(3)+KM2f*x(4)))-(kc3*E3*x(4)/(x(4)+KM3)));        % Variation of ME4P   
     GN*((kc3*E3*x(4)/(x(4)+KM3))-(kc4*E4*x(5)/(x(5)+KM4)));        % Variation of CDP-ME
     GN*((kc4*E4*x(5)/(x(5)+KM4))-(kc5*E5*x(6)/(x(6)+KM5)));        % Variation of CDP-ME2P
     GN*((kc5*E5*x(6)/(x(6)+KM5))-(kc6*E6*x(7)/(x(7)+KM6)));        % Variation of MEcPP
     GN*((kc6*E6*x(7)/(x(7)+KM6))-(kc7*E7a*x(8)/(x(8)+KM7))- (kc7*E7b*x(8)/(x(8)+KM7))); % Variation of HMB-PP
     GN*((kc7*E7a*x(8)/(x(8)+KM7))+(kc8f*E8*x(10)/(x(10)+KM8f*(1+(x(11)/Kic1))))-(kc8r*E8*x(9)/(x(9)+KM8r*(1+(x(11)/Kic1))))-((kc9a*E9*KM9b*x(9)+kc9b*E9*KM9a*x(10))/(KM9b*x(9)+KM9a*x(10)+KM9a*KM9b))); %Variation of DMAPP  
     GN*((kc7*E7b*x(8)/(x(8)+KM7))+(kc8r*E8*x(9)/(x(9)+KM8r*(1+(x(11)/Kic1))))-(kc8f*E8*x(10)/(x(10)+KM8f*(1+(x(11)/Kic1))))-((kc9a*E9*KM9b*x(9)+kc9b*E9*KM9a*x(10))/(KM9b*x(9)+KM9a*x(10)+KM9a*KM9b))); %Variation of IPP 
     GN*(((kc9a*E9*KM9b*x(9)+kc9b*E9*KM9a*x(10))/(KM9b*x(9)+KM9a*x(10)+KM9a*KM9b))- (kc10*E10*x(11)/(x(11)+KM10))); %Variation of GPP     
     GN*((kc10*E10*x(11)/(x(11)+KM10))-(kc11*E11*x(12)/(x(12)+KM11))); % Variation of LIM
     GN*((kc11*E11*x(12)/(x(12)+KM11))-(kc12*E12*x(13)/(x(13)+KM12))); % Variation of IPPol
     GN*((kc12*E12*x(13)/(x(13)+KM12))-(kc13*E13*x(14)/(x(14)+KM13))); % Variation of IPPone
     GN*((kc13*E13*x(14)/(x(14)+KM13))-(kc14*E14*x(15)/(x(15)+KM14))); % Variation of CIPUL
     GN*((kc14*E14*x(15)/(x(15)+KM14))-(kc16a*E16a*x(16)/(x(16)+KM16a*(1+z*(x(17))/Kic2)))-(kc16b*E16b*x(16)/(x(16)+KM16b*(1+z*(x(17))/Kic2)))-(w*kc16a*E16a*x(16)/(KM16a+x(16)*(1+x(16)/Kis)))-(w*kc16b*E16b*x(16)/(KM16b+x(16)*(1+x(16)/Kis)))-(kc15*E15*x(16)/(x(16)+KM15))); % Variation of PUL
     GN*(kc15*E15*x(16)/(x(16)+KM15));                              % Variation of MF
     GN*((kc16b*E16b*x(16)/(x(16)+KM16b*(1+z*(x(17))/Kic2)))+(w*kc16b*E16b*x(16)/(KM16b+x(16)*(1+x(16)/Kis)))-(kc17b*E17b*x(18)/(x(18)+KM17b))-(kc18b*E18b*x(18)/(x(18)+KM18b))); % Variation of IMone
     GN*((kc16a*E16a*x(16)/(x(16)+KM16a*(1+z*(x(17))/Kic2)))+(w*kc16a*E16a*x(16)/(KM16a+x(16)*(1+x(16)/Kis)))-((KM18ar*kc18af*E18a*x(19)-KM18af*kc18ar*E18a*x(20))/(KM18af*KM18ar+KM18ar*x(19)+KM18af*x(20)))-(kc17a*E17a*x(19)/(x(19)+KM17a))); % Variation of Mone
     GN*((KM18ar*kc18af*E18a*x(19)-KM18af*kc18ar*E18a*x(20))/(KM18af*KM18ar+KM18ar*x(19)+KM18af*x(20))); % Variation of NMol
     GN*(kc17a*E17a*x(19)/(x(19)+KM17a));                             % Variation of Mol
     GN*(kc18b*E18b*x(18)/(x(18)+KM18b));                             % Variation of IMol
     GN*(kc17b*E17b*x(18)/(x(18)+KM17b))];                            % Variation of NIMol
      
  

 end
