clear all;
% ��������������Ŀ������
time=0.01:0.01:10;           %ʱ�����
noise=(rand(1,1000)-0.5)*4;   %�������
input=sin(time);             %�ź�
p=noise;                   %��������ΪADALINE����������
t=input+noise;              %������+�ź���ΪĿ������
% ��������������
net=newlin([-1 1],1,0,0.0005);
% ���������������Ӧ����(ѵ��)
net.adaptParam.passes=70;
[net,y,output]=adapt(net,p,t);  %����ź�outputΪ������������е����
%�����ź�,��������������ź�,����źŵĲ���
hold on;
% �����źŵĲ���
subplot(3,1,1);plot(time,input,'r');
title('�źŲ��� sin(t)');
subplot(3,1,2);plot(time,t,'m'); %���Ƶ�����������źŵĲ���
xlabel('t');title('����������� sin(t)+noise(t)');
% ��������źŵĲ���
subplot(3,1,3);plot(time,output,'b');
xlabel('t');title('����źŲ��� y(t)');