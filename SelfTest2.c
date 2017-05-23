#pragma token off

int main()
{
    // //void a = 0;
    // void a[1] = {};
    // void a[-1];
    // const void a;
    // func();
    // for(int i = 0 ; ; )
    // {
    //
    // }
    //if(a == 0) a = 1;
    //while(1) a = 2;

    int a = func();
    int a[2] = {func() , 1 };
    int a[1] = {2, , 1};
}

void func(int hello[1][2]);
void func();
