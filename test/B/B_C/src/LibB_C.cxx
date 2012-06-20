// --------------------------------------
#include <iostream>
#include <B_C/LibB_C.hxx>

CB_C::CB_C ()
{
    std::cout << "Constructor CB_C" << std::endl;
}

CB_C::~CB_C ()
{
    std::cout << "Destructor CB_C" << std::endl;
}

void CB_C::f ()
{
    std::cout << "CB_C.f" << std::endl;
}
// --------------------------------------
