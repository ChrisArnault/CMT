
#ifndef __LibB_H_hxx__
#define __LibB_H_hxx__
// --------------------------------------
#include <B_E/LibB_E.hxx>
#include <B_F/LibB_F.hxx>


#ifdef _MSC_VER
#define DllExport __declspec( dllexport )
#else
#define DllExport
#endif


class DllExport CB_H
{
public:
    CB_H ();
    ~CB_H ();
    void f();
private:
    CB_E oB_E;
    CB_F oB_F;
};
// --------------------------------------
#endif

