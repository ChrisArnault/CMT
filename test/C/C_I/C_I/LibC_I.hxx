
#ifndef __LibC_I_hxx__
#define __LibC_I_hxx__
// --------------------------------------


#ifdef _MSC_VER
#define DllExport __declspec( dllexport )
#else
#define DllExport
#endif


class DllExport CC_I
{
public:
    CC_I ();
    ~CC_I ();
    void f();
private:
};
// --------------------------------------
#endif

