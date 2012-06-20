
#ifndef __LibB_C_hxx__
#define __LibB_C_hxx__
// --------------------------------------


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
};
// --------------------------------------
#endif

