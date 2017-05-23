#pragma token off

int main()
{
    //Statement first
    a = 1;
    //Declaration second
    int a = 1;

    //Function Declaration in Compound Statement
    int a(int b);

    // Conditional Expression
    a = (a > 1) ? 1+2 : a+3;

    // Return nothing
    return;
}
