
#ifndef __LibA_B_hxx__
#define __LibA_B_hxx__
// --------------------------------------


#ifdef _MSC_VER
#define DllExport __declspec( dllexport )
#else
#define DllExport
#endif


class DllExport CA_B
{
public:
    CA_B ();
    ~CA_B ();
    void f();
private:
};
// --------------------------------------
#endif

