
#ifndef __LibB_F_hxx__
#define __LibB_F_hxx__
// --------------------------------------


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
};
// --------------------------------------
#endif

