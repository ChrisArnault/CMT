// --------------------------------------
#include <iostream>
#include <B_H/LibB_H.hxx>

CB_H::CB_H ()
{
    std::cout << "Constructor CB_H" << std::endl;
}

CB_H::~CB_H ()
{
    std::cout << "Destructor CB_H" << std::endl;
}

void CB_H::f ()
{
    std::cout << "CB_H.f" << std::endl;
    oB_E.f();
    oB_F.f();
}
// --------------------------------------
