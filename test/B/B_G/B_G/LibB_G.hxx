
#ifndef __LibB_G_hxx__
#define __LibB_G_hxx__
// --------------------------------------


#ifdef _MSC_VER
#define DllExport __declspec( dllexport )
#else
#define DllExport
#endif


class DllExport CB_G
{
public:
    CB_G ();
    ~CB_G ();
    void f();
private:
};
// --------------------------------------
#endif

