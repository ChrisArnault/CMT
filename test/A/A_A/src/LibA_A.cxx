// --------------------------------------
#include <iostream>
#include <A_A/LibA_A.hxx>

CA_A::CA_A ()
{
    std::cout << "Constructor CA_A" << std::endl;
}

CA_A::~CA_A ()
{
    std::cout << "Destructor CA_A" << std::endl;
}

void CA_A::f ()
{
    std::cout << "CA_A.f" << std::endl;
    oA_B.f();
}
// --------------------------------------
