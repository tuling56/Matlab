clear all;
%��ʼ�������֪����
pr1=[0 1;0 1];              %���������֪������������ÿ��Ԫ�ص�ֵ��
net1=newp(pr1,3);           %���������֪����
%ָ�������֪����Ȩֵ��ʼ������Ϊ�������
net1.inputweights{1}.initFcn='rands'; 
%ָ�������֪������ֵ��ʼ������Ϊ�������
net1.biases{1}.initFcn='rands';
net1=init(net1);           %��ʼ�������֪����
iw1=net1.iw{1};            %�����֪�����Ȩֵ����
b1=net1.b{1};              %�����֪�������ֵ����
%�����֪�������
p1=[0 0;0 1;1 0;1 1]';     %�����֪������������ѵ��������
[a1,pf]=sim(net1,p1);      %�����֪�������
%��ʼ���ڶ���֪����
pr2=[0 1;0 1;0 1];         %���õڶ���֪������������ÿ��Ԫ�ص�ֵ��
net2=newp(pr2,1);          %����ڶ���֪����
%ѵ���ڶ���֪����
net2.trainParam.epochs=10;
net2.trainParam.show=1;
p2=ones(3,4);              %��ʼ���ڶ���֪�������������
p2=p2.*a1;                 %�����֪����ķ�����������Ϊ�ڶ���֪�������������
t2=[0 1 1 0];              %�ڶ���֪�����Ŀ������
%ѵ���ڶ���֪����
[net2,tr2]=train(net2,p2,t2);
disp('���ѵ�����̾�����ÿһ����Ϊ��')
epoch2=tr2.epoch           %���ѵ�����̾�����ÿһ����
disp('���ÿһ��ѵ����������Ϊ��')
perf2=tr2.perf             %���ÿһ��ѵ����������
disp('�ڶ���֪�����Ȩֵ����Ϊ��')
iw2=net2.iw{1}
disp('�ڶ���֪�������ֵ����Ϊ��')
b2=net2.b{1}
%�洢ѵ���������
save net36 net1 net2

 clear all;                   %��������ռ��б���
load net36 net1 net2         %����ѵ���������
%�����֪�������
p1=[0 0;0 1;1 0;1 1]';       %�����֪������������
a1=sim(net1,p1);             %�����֪���������
%�����֪������棬�����������
p2=ones(3,4);                %��ʼ���ڶ���֪�������������
p2=p2.*a1;          %�����֪����ķ�����������Ϊ�ڶ���֪�������������
a2=sim(net2,p2)