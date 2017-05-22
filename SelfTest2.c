#pragma token off

int a = 1;
const int a = 1;
int b = 1 + 1;
const char b = "aa";
const char b = 'a';
const bool b = true;
int main()
{
    int a = 1;
    const char b = 'a';
    const bool b = true;
    a = func();
    if(a == 1)
    {
        int a = 1;
        if(a+2*b >= 1)
        {

        }
        else
        {

        }
    }
}
