// --------------------------------------
#include <iostream>
#include <B_F/LibB_F.hxx>

CB_F::CB_F ()
{
    std::cout << "Constructor CB_F" << std::endl;
}

CB_F::~CB_F ()
{
    std::cout << "Destructor CB_F" << std::endl;
}

void CB_F::f ()
{
    std::cout << "CB_F.f" << std::endl;
}
// --------------------------------------
