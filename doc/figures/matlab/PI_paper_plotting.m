%% Simple plotting tool using IRHF exported from final.m script


%% Import filter
inv_model_nnf = load('inv_model_nnf.mat');
model =  zpk(-2*pi*5e-6, -2.*pi.*[1.3e-5; 9.5e-5; 5e-5],1);
model = model*abs(H(1))/abs(squeeze(freqresp(model, 0))); %Get the gain correct for the filter
[z, p, k] = zpkdata(model);

[z_inv,p_inv,k_inv] = zpkdata(inv_model_nnf.inv_model);
inv_model_unity = zpk(z_inv,p_inv,1);

t = 1:60:(1.5*86400); 

%Making the step
unitstep = zeros(size(t)); 
unitstep(t>=18000) = 1; 


step_size = 1; 

y = lsim(model, unitstep, t);
y_inv = lsim(inv_model_unity, unitstep, t);
y_inv_sph = lsim(model,y_inv,t);

%t_new = [zeros(600,1),t]
figure(131)
line_thickness = 3;
subplot(2,1,1)
plot(t/3600,unitstep, 'Linewidth', line_thickness)
hold on
plot(t/3600,y_inv,'--', 'Linewidth',line_thickness)
xlim([1/3600,1.5*86400/3600])
ylabel('RH power[W]','FontSize',18)
ldg1 = legend('RH step input','RH step input passed through [H(s)]^{-1*}','Location','Best','FontSize',13); 

ldg1.FontSize = 13; 
subplot(2,1,2)
plot(t/3600,-y, 'Linewidth',line_thickness)
hold on
plot(t/3600,-y_inv_sph,'--', 'Linewidth',line_thickness);
xlim([1/3600,1.5*86400/3600])
ylabel('Spherical power [\mu diopter]','FontSize',18)

xlabel('time [hr]','FontSize',18)
ldg2 = legend('RH step input','RH step input passed through [H(s)]^{-1*}','Location','Best','Fontsize',13); 
ldg2.FontSize = 13; 

sup = suptitle('RH natural step response vs response with real time digital filtering using [H(s)]^{-1*}'); 

sup.FontSize = 20; 

%ax = gca
%ti = ax.TightInset

%%
figure(510)


