%module freetype
%include "cpointer.i"
%include "carrays.i"
%{
#include "freetype2/ftheader.h"
#include "freetype2/ftstdlib.h"
#include "freetype2/fttypes.h"
//#include "freetype/ftserv.h"
#include "freetype2/ftconfig.h"
#include "freetype2/ft2build.h"
#include "freetype2/internal.h"   
#include "freetype2/ftmodapi.h"
#include "freetype2/ftimage.h"
#include "freetype2/ftbbox.h"
#include "freetype2/ftsnames.h"   
#include "freetype2/ftvalid.h"
#include "freetype2/ttnameid.h"
#include "freetype2/tttables.h"
#include "freetype2/t1types.h"
//#include "freetype/svgldict.h";
#include "freetype2/ftobjs.h"   
#include "freetype2/freetype.h"
%}


%ignore ft_default_raster;
/* %ignore GlyphDict; */


/*
struct jmp_buf is declared as an array on Linux and FreeBSD (looks the same on Cygwin too):

struct _jmp_buf { int buf[JBLEN+1]; }
typedef struct _jmp_buf jmp_buf[1];

<RANT>
It's specifically declared this way to prevent copying 
the machine-specific state used by setjmp and longjmp by assignment. 
setjmp and longjmp are reasonably dangerous functions 
to call if you don't know what you're doing, 
meaning they cause your program 
to jump back several frames previous in the stack. 
You don't go about setting them cavalierly EXCEPT THROUGH THE setjmp function. 
If the jmp_buf has invalid contents 
or refers to a stack frame that's no longer valid 
-- your program just became a new trojan vehicle.
</RANT>

*/

%ignore FT_ValidatorRec_::jump_buffer;

%include "freetype2/zlimit.h"; 
%include "freetype2/ftheader.h";
%include "freetype2/ftstdlib.h";
%include "freetype2/fttypes.h";
//%include "freetype/ftserv.h";
%include "freetype2/ftconfig.h";
%include "freetype2/ft2build.h";
%include "freetype2/ftheader.h";
%include "freetype2/internal.h"   
%include "freetype2/ftmodapi.h"
%include "freetype2/ftimage.h";
%include "freetype2/ftbbox.h";
%include "freetype2/ftsnames.h";   
%include "freetype2/ftvalid.h";
%include "freetype2/ttnameid.h";
%include "freetype2/tttables.h";
%include "freetype2/t1types.h";
%include "freetype2/ftobjs.h"  ; 
%include "freetype2/freetype.h";


%pointer_functions(FT_Library, Pointer_FT_Library);
%pointer_functions(FT_Face, Pointer_FT_Face);
%pointer_functions(FT_UInt, Pointer_FT_UInt);
%pointer_functions(FT_ULong, Pointer_FT_ULong);
%pointer_functions(FT_Bitmap_Size, Pointer_FT_Bitmap_Size);


%array_functions(FT_Byte,string); 
%array_functions(FT_CharMap,charmaps); 


/* Here, the auxiliary macro to wrap a macro */
%define %wrapmacro(type, name, lparams, lnames)
%rename(name) SWIGMACRO_##name;
%inline %{
type SWIGMACRO_##name(lparams) {
  return name(lnames);
  }
%}
%enddef

%wrapmacro(FT_EXPORT(FT_Int), FT_HAS_HORIZONTAL,FT_Face face,face) ;
%wrapmacro(FT_EXPORT(FT_Int), FT_HAS_VERTICAL,FT_Face face,face) ;
%wrapmacro(FT_EXPORT(FT_Int), FT_HAS_KERNING,FT_Face face,face) ;
%wrapmacro(FT_EXPORT(FT_Int), FT_IS_SCALABLE,FT_Face face,face) ;
%wrapmacro(FT_EXPORT(FT_Int), FT_IS_SFNT,FT_Face face,face) ;
%wrapmacro(FT_EXPORT(FT_Int), FT_IS_FIXED_WIDTH,FT_Face face,face) ;
%wrapmacro(FT_EXPORT(FT_Int), FT_HAS_FIXED_SIZES,FT_Face face,face) ;
%wrapmacro(FT_EXPORT(FT_Int), FT_HAS_GLYPH_NAMES,FT_Face face,face) ;
%wrapmacro(FT_EXPORT(FT_Int), FT_HAS_MULTIPLE_MASTERS,FT_Face face,face) ;
%wrapmacro(FT_EXPORT(FT_Int), FT_IS_CID_KEYED,FT_Face face,face) ;
%wrapmacro(FT_EXPORT(FT_Int), FT_IS_TRICKY,FT_Face face,face) ;

%wrapmacro(FT_Validator, FT_VALIDATOR, FT_Validator x,x) ;

  
/* 

%inline %{
FT_EXPORT( FT_Int ) SWIGMACRO_FT_IS_SFNT( FT_Face face )   { return FT_IS_SFNT( face ) ; } 
FT_EXPORT( FT_Int ) SWIGMACRO_FT_IS_SCALABLE( FT_Face face ) { return FT_IS_SCALABLE( face ) ; } 
%}
*/

/* #define FT_IS_SFNT( face )   ( face->face_flags & FT_FACE_FLAG_SFNT )  */

/*
type *new_<name>()
     Creates a new object of type type and returns a pointer to it. In C, the object is created using calloc(). In C++, new
     is used.
type *copy_<name>(type value)
     Creates a new object of type type and returns a pointer to it. An initial value is set by copying it from value. In C, the
     object is created using calloc(). In C++, new is used.
type *delete_<name>(type *obj)
     Deletes an object type type.
void <name>_assign(type *obj, type value)
     Assigns *obj = value.
type <name>_value(type *obj)
     Returns the value of *obj.
When using this macro, type may be any type and name must be a legal identifier in the target language. name should not
correspond to any other name used in the interface file.

*/ 

/*
%inline %{
FT_EXPORT( FT_Error )  uti_FT_Init_FreeType( FT_Library  alibrary ){
 return FT_Init_FreeType( &alibrary );
}
%}
*/		
