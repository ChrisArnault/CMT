// --------------------------------------
#include <iostream>
#include <A_B/LibA_B.hxx>

CA_B::CA_B ()
{
    std::cout << "Constructor CA_B" << std::endl;
}

CA_B::~CA_B ()
{
    std::cout << "Destructor CA_B" << std::endl;
}

void CA_B::f ()
{
    std::cout << "CA_B.f" << std::endl;
}
// --------------------------------------
