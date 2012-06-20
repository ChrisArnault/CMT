
#ifndef __LibB_D_hxx__
#define __LibB_D_hxx__
// --------------------------------------
#include <B_E/LibB_E.hxx>


#ifdef _MSC_VER
#define DllExport __declspec( dllexport )
#else
#define DllExport
#endif


class DllExport CB_D
{
public:
    CB_D ();
    ~CB_D ();
    void f();
private:
    CB_E oB_E;
};
// --------------------------------------
#endif

