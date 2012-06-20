
#ifndef __LibB_E_hxx__
#define __LibB_E_hxx__
// --------------------------------------


#ifdef _MSC_VER
#define DllExport __declspec( dllexport )
#else
#define DllExport
#endif


class DllExport CB_E
{
public:
    CB_E ();
    ~CB_E ();
    void f();
private:
};
// --------------------------------------
#endif

