clear all;
net=newp([-2 2;-2 2],1);       %创建感知神经网络
%给权值与阈值赋值
net.IW{1,1}=[-1,1];
net.b{1}=[1];
%下面来看这个感知器网络对两个输入信号的输出如何，两个信号分别位于感知器两个边界。
p1=[1;1];         %第一个输入信号
a1=sim(net,p1)    %对第一个输入信号仿真
p2=[1;-1];         %第二个输入信号
a2=sim(net,p2)     %对第二个输入信号进行仿真
%若将两个输入信号组成一个数列，则输出量也为一个数列。
p3={[1;1],[1;-1]};
a3=sim(net,p3)      %对数列进行仿真
