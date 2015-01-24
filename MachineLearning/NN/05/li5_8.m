 clear all;
P=[0.4036 0.4154 0.5352 0.5524 0.7709 0.7589;...
   0.4365 0.4711 0.6408 0.6528 0.7812 0.7965;...
   0.4860 0.4639 0.6145 0.6234 0.8204 0.8125;...
   0.5161 0.4981 0.6299 0.6715 0.8425 0.8506;...
   0.3419 0.3806 0.7154 0.7025 0.8622 0.8709];
net=newc(minmax(P),3,0.1);

net=init(net);
net.trainParam.epochs=200;
net=train(net,P);

 Y=sim(net,P)
 Yc=vec2ind(Y)
 
  P_test=[0.7601 0.8123 0.8079 0.8450 0.8792]';
Y_test=sim(net,P_test)
Yc_test=vec2ind(Y_test)