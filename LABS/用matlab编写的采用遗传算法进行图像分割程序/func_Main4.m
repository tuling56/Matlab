%-----------   Input   ----------------
Orig_I1=imread('new4.bmp');
%Orig_I1=a1;
Orig_I = double(Orig_I1) / 256;
figure,imshow(Orig_I);title('ԭ��ͼ��');axis on;

%-----------   Pre-processing   ----------------
now=[];
[nRow, nColumn] = size(Orig_I);
L=16;  %the size of moving windows
%expand_image=zeros(2*nRow,2*nColumn);
b=flipdim(Orig_I,1);
c=[b;Orig_I;b];
d=flipdim(c,2);
expand_image=[d c d];
seg_image=zeros(L);
[Row, Column] = size(expand_image);
%-----------   segmenting the image   ----------------  
 for i=nRow+1:Row-nRow
  for j=nColumn+1:Column-nColumn
           x=i;y=j;
         for m=1:L
              for n=1:L
                  seg_image(m,n)=expand_image(x-L/2+1,y-L/2+1);
                  y=y+1;
              end
              x=x+1;
              y=j;
          end     
          %-----------   Wavelet Decomposition   ----------------
          %n = size(seg_image,1);
          %n_log = log2(n); 
          level = 2;
          type = 'bior4.4';
          [Lo_D,Hi_D,Lo_R,Hi_R] = wfilters(type);
          [E_W, S] = func_DWT(seg_image, level, Lo_D, Hi_D);
          E_W=E_W';
          now=[now;E_W];
      end
 end
 %normalize the now matrix
[now_row,now_column]=size(now);
 max_now=max(now);
 min_now=min(now);
 fm=max_now-min_now;
 for j=1:now_column
    for i=1:now_row
        now(i,j)=( now(i,j)-min_now(j) )/ fm(j);
   end
 end
% FCM method making sort
[center,U,obj_fcn] = fcm(now,4);
maxU = max(U);                    
index1 = find(U(1,:) == maxU);    % Find the data points with highest grade of membership in cluster 1
index2 = find(U(2,:) == maxU);    % Find the data points with highest grade of membership in cluster 2
index3 = find(U(3,:) == maxU);    % Find the data points with highest grade of membership in cluster 3
for r=1:nRow
    for c=1:nColumn
         m=(r-1)*nColumn+c;
         size1=size(index1,2);
         size2=size(index2,2);
         size3=size(index3,2);
         q=1;
         size_now=max(max(size1,size2),size3);
         while (q<size_now+1)
              if q<size1+1  
                   if index1(q)==m
                       Orig_I1(r,c)=255;
                       break;
                   end
               end
               if q<size2+1
                   if index2(q)==m 
                   Orig_I1(r,c)=128;
                   break;
                   end
               end
               if q<size3+1
                   if index3(q)==m 
                   Orig_I1(r,c)=64;
                   break;
                   end
               end
               q=q+1;
           end
          if(q==size_now+1)
             Orig_I1(r,c)=0;
          end
              
     end
end
                    
figure,imshow(Orig_I1);title('�ָ��ͼ��');axis on;                    
               