
#ifndef __LibB_B_hxx__
#define __LibB_B_hxx__
// --------------------------------------
#include <B_F/LibB_F.hxx>
#include <B_G/LibB_G.hxx>


#ifdef _MSC_VER
#define DllExport __declspec( dllexport )
#else
#define DllExport
#endif


class DllExport CB_B
{
public:
    CB_B ();
    ~CB_B ();
    void f();
private:
    CB_F oB_F;
    CB_G oB_G;
};
// --------------------------------------
#endif

