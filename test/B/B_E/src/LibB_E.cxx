// --------------------------------------
#include <iostream>
#include <B_E/LibB_E.hxx>

CB_E::CB_E ()
{
    std::cout << "Constructor CB_E" << std::endl;
}

CB_E::~CB_E ()
{
    std::cout << "Destructor CB_E" << std::endl;
}

void CB_E::f ()
{
    std::cout << "CB_E.f" << std::endl;
}
// --------------------------------------
