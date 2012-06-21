// --------------------------------------
#include <iostream>
#include <C_I/LibC_I.hxx>

CC_I::CC_I ()
{
    std::cout << "Constructor CC_I" << std::endl;
}

CC_I::~CC_I ()
{
    std::cout << "Destructor CC_I" << std::endl;
}

void CC_I::f ()
{
    std::cout << "CC_I.f" << std::endl;
}
// --------------------------------------
