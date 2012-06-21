
#ifndef __LibB_C_hxx__
#define __LibB_C_hxx__
// --------------------------------------
#include <B_F/LibB_F.hxx>


#ifdef _MSC_VER
#define DllExport __declspec( dllexport )
#else
#define DllExport
#endif


class DllExport CB_C
{
public:
    CB_C ();
    ~CB_C ();
    void f();
private:
    CB_F oB_F;
};
// --------------------------------------
#endif

