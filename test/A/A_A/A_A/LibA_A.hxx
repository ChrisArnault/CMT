
#ifndef __LibA_A_hxx__
#define __LibA_A_hxx__
// --------------------------------------
#include <A_B/LibA_B.hxx>


#ifdef _MSC_VER
#define DllExport __declspec( dllexport )
#else
#define DllExport
#endif


class DllExport CA_A
{
public:
    CA_A ();
    ~CA_A ();
    void f();
private:
    CA_B oA_B;
};
// --------------------------------------
#endif

