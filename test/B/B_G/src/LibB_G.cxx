// --------------------------------------
#include <iostream>
#include <B_G/LibB_G.hxx>

CB_G::CB_G ()
{
    std::cout << "Constructor CB_G" << std::endl;
}

CB_G::~CB_G ()
{
    std::cout << "Destructor CB_G" << std::endl;
}

void CB_G::f ()
{
    std::cout << "CB_G.f" << std::endl;
}
// --------------------------------------
