// --------------------------------------
#include <iostream>
#include <B_D/LibB_D.hxx>

CB_D::CB_D ()
{
    std::cout << "Constructor CB_D" << std::endl;
}

CB_D::~CB_D ()
{
    std::cout << "Destructor CB_D" << std::endl;
}

void CB_D::f ()
{
    std::cout << "CB_D.f" << std::endl;
}
// --------------------------------------
