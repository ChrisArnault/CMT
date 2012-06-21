// --------------------------------------
#include <iostream>
#include <B_B/LibB_B.hxx>

CB_B::CB_B ()
{
    std::cout << "Constructor CB_B" << std::endl;
}

CB_B::~CB_B ()
{
    std::cout << "Destructor CB_B" << std::endl;
}

void CB_B::f ()
{
    std::cout << "CB_B.f" << std::endl;
    oB_F.f();
    oB_G.f();
}
// --------------------------------------
