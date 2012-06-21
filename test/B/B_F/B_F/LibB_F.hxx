
#ifndef __LibB_F_hxx__
#define __LibB_F_hxx__
// --------------------------------------
#include <B_G/LibB_G.hxx>


#ifdef _MSC_VER
#define DllExport __declspec( dllexport )
#else
#define DllExport
#endif


class DllExport CB_F
{
public:
    CB_F ();
    ~CB_F ();
    void f();
private:
    CB_G oB_G;
};
// --------------------------------------
#endif

