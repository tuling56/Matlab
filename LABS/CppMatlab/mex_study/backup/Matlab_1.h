//该文件是自己创建的,因为在matlab中使用的时候出现了这种错误，缺失头文件

/*
>> loadlibrary('Matlab_1.dll')
Error using loadlibrary>lFullPath (line 587)
Could not find file Matlab_1.h.

Error in loadlibrary (line 220)
        header=lFullPath(header);

*/
extern "C" __declspec(dllexport) void hilb(double *y,int n);

