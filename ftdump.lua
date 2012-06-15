require("freetype")

name_id =  {  
    [freetype.TT_NAME_ID_COPYRIGHT] = "copyright",
    [freetype.TT_NAME_ID_FONT_FAMILY] = "font family",
    [freetype.TT_NAME_ID_FONT_SUBFAMILY] = "font subfamily",
    [freetype.TT_NAME_ID_UNIQUE_ID] = "unique ID",
    [freetype.TT_NAME_ID_FULL_NAME] = "full name",
    [freetype.TT_NAME_ID_VERSION_STRING] = "version string",
    [freetype.TT_NAME_ID_PS_NAME] = "PostScript name",
    [freetype.TT_NAME_ID_TRADEMARK] = "trademark",
    --   /* the following values are from the OpenType spec */
    [freetype.TT_NAME_ID_MANUFACTURER] = "manufacturer",
    [freetype.TT_NAME_ID_DESIGNER] = "designer",
    [freetype.TT_NAME_ID_DESCRIPTION] = "description",
    [freetype.TT_NAME_ID_VENDOR_URL] = "vendor URL",
    [freetype.TT_NAME_ID_DESIGNER_URL] = "designer URL",
    [freetype.TT_NAME_ID_LICENSE] = "license",
    [freetype.TT_NAME_ID_LICENSE_URL] = "license URL",
    -- /* number 15 is reserved */
    [freetype.TT_NAME_ID_PREFERRED_FAMILY] = "preferred family",
    [freetype.TT_NAME_ID_PREFERRED_SUBFAMILY] = "preferred subfamily",
    [freetype.TT_NAME_ID_MAC_FULL_NAME] = "Mac full name",
    --   /* The following code is new as of 2000-01-21 */
    [freetype.TT_NAME_ID_SAMPLE_TEXT] = "sample text",
    --   /* This is new in OpenType 1.3 */
    [freetype.TT_NAME_ID_CID_FINDFONT_NAME] = "CID `findfont' name"
  }

platform_id =   {
    [freetype.TT_PLATFORM_APPLE_UNICODE] =  "Apple (Unicode)";
    [freetype.TT_PLATFORM_MACINTOSH] =  "Macintosh";
    [freetype.TT_PLATFORM_ISO] =  "ISO (deprecated)";
    [freetype.TT_PLATFORM_MICROSOFT] =  "Microsoft";
    [freetype.TT_PLATFORM_CUSTOM] =  "custom";
    [freetype.TT_PLATFORM_ADOBE] =  "Adobe";
  }


FT_Err_ok = 0


function put_unicode_be16( str, str_len, indent )

    local ch = 0;
    local  i, j
    local res = ''
    for  i = 0, str_len-1,2 do
      ch =  freetype.string_getitem(str,i)*256 + freetype.string_getitem(str,i+1);
      --print(ch)
      if      ch<256 and  string.char(ch) == '\n' then res = res .."\n"
       elseif ch<256 and   string.char(ch) == '\r' then res = res .."\r"
       elseif ch<256 and   string.char(ch) == '\t' then res = res .."\t"
       elseif ch<256 and   string.char(ch) == '\\' then res = res .."\\\\"
       elseif ch<256 and   string.char(ch) == '"' then res = res .."\\\"" -- "
       elseif               ch ==  0x00A9 then res = res .. "(c)"
       elseif               ch ==  0x00AE then res = res .. "(r)"
       elseif               ch ==  0x2013 then res = res .. "--"
       elseif               ch ==  0x2019 then res = res .. "\'"
       elseif               ch ==  0x2122 then res = res .. "(tm)"
       elseif  ( ch < 256 ) then res = res .. string.char(ch) 
       else  res = res .. string.format("\\U+%04X", ch )
      end
    end
    print(res)
end

function Print_Fixed( face )
 print("FUNCTION Print_Fixed( face ) MUST BE CHECKED" )
 print( "fixed size\n" );
 for i=0,face.num_fixed_sizes-1 do
      local bsize = freetype.new_Pointer_FT_Bitmap_Size()
      bsize = face.available_sizes + i;
      print(string.format( "   %3d: height %d, width %d",
              i, bsize.height, bsize.width ))
      print(string.format("        size %.3f, x_ppem %.3f, y_ppem %.3f",
              bsize.size / 64.0,
              bsize.x_ppem / 64.0, bsize.y_ppem / 64.0 ))
 end
--[=[
  void
  Print_Fixed( FT_Face  face )
  {
    int  i;


    /* num_fixed_size */
    printf( "fixed size\n" );

    /* available size */
    for ( i = 0; i < face->num_fixed_sizes; i++ )
    {
      FT_Bitmap_Size*  bsize = face->available_sizes + i;


      printf( "   %3d: height %d, width %d\n",
              i, bsize->height, bsize->width );
      printf( "        size %.3f, x_ppem %.3f, y_ppem %.3f\n",
              bsize->size / 64.0,
              bsize->x_ppem / 64.0, bsize->y_ppem / 64.0 );
    }
  }

]=]
end
 


function  Print_Charmaps( face, verbose )
 local active = -1 
 active = freetype.FT_Get_Charmap_Index( face.charmap )
 -- /* CharMaps */
 --print( "charmaps",face.num_charmaps-1,swig_type(face.charmaps),freetype.charmaps_getitem(face.charmaps,2).platform_id ) 
 for i=0, face.num_charmaps-1 do
    local r = ''
    if i == active then r = '(active)' end 
    print(string.format("   %s: platform %s, encoding %s, language %s %s", 
           i,
	   freetype.charmaps_getitem(face.charmaps,i).platform_id,
	   freetype.charmaps_getitem(face.charmaps,i).encoding_id,
	   freetype.FT_Get_CMap_Language_ID( freetype.charmaps_getitem(face.charmaps,i)), 
	   r 
	   )) 
    verbose = 1
    if verbose ~= nil then 
      freetype.FT_Set_Charmap( face, freetype.charmaps_getitem(face.charmaps,i ));
      local charcode, gindex = freetype.new_Pointer_FT_ULong(),freetype.new_Pointer_FT_UInt()
      --      print(freetype.Pointer_FT_ULong_value(charcode),freetype.Pointer_FT_UInt_value(gindex))
      charcode = freetype.FT_Get_First_Char( face, gindex );
      --print(charcode,freetype.Pointer_FT_UInt_value(gindex))
      while freetype.Pointer_FT_UInt_value(gindex) > 0  do 
          print( string.format("      0x%04x => %d", charcode, freetype.Pointer_FT_UInt_value(gindex) ))
          charcode = freetype.FT_Get_Next_Char( face, charcode, gindex );
      end
      print();
    end 	       
 end
end

function Print_Sfnt_Names( face )
  local num_name,i
  local name = freetype.FT_SfntName()
  print( "font string entries" );
  num_names = freetype.FT_Get_Sfnt_Name_Count( face );
  for i=1,num_names do
    local error = freetype.FT_Get_Sfnt_Name( face, i-1, name );
    if error == FT_Err_ok then
      print(name_id[name.name_id] or "UNKNOWN",
            '['.. platform_id[name.platform_id] .. ']' or "[UNKNOWN]") 
      if name.platform_id == freetype.TT_PLATFORM_APPLE_UNICODE then
	if name.encoding_id == freetype.TT_APPLE_ID_DEFAULT or 
	   name.encoding_id == freetype.TT_APPLE_ID_UNICODE_1_1 or     
	   name.encoding_id == freetype.TT_APPLE_ID_ISO_10646 or 
	   name.encoding_id == freetype.TT_APPLE_ID_UNICODE_2_0  then
           -- /* FIXME: print unicode */
            local _str,str = name.string ,''
            --for i=0,name.string_len-1 do str = str .. string.char(freetype.string_getitem(_str,i)) end
            --print(str)
            --print(name.string,name.string_len,6)
	    put_unicode_be16(_str,name.string_len,6)
	else 
	    print(string.format("{unsupported encoding %d}", name.encoding_id) )
	end
      elseif name.platform_id == freetype.TT_PLATFORM_MACINTOSH then
	if name.encoding_id == freetype.TT_MAC_ID_ROMAN then 
           -- /* FIXME: convert from MacRoman to ASCII/ISO8895-1/whatever */
           -- /* (MacRoman is mostly like ISO8895-1 but there are         */
           --  /* differences)                                             */
          local _str,str = name.string ,''
          for i=0,name.string_len-1 do str = str .. string.char(freetype.string_getitem(_str,i)) end
          print(str)
	else 
	  print(string.format("{unsupported encoding %d}", name.encoding_id) )
	end
      elseif name.platform_id == freetype.TT_PLATFORM_ISO then
        if name.encoding_id == freetype.TT_ISO_ID_7BIT_ASCII or
	   name.encoding_id == freetype.TT_ISO_ID_8859_1 then 
           local _str,str = name.string ,''
           for i=0,name.string_len-1 do str = str .. string.char(freetype.string_getitem(_str,i)) end
           print(str)
        elseif name.encoding_id == freetype.TT_ISO_ID_10646 then 
           -- /* FIXME: convert from MacRoman to ASCII/ISO8895-1/whatever */
           -- /* (MacRoman is mostly like ISO8895-1 but there are         */
           --  /* differences)                                             */
            local _str,str = name.string ,''
            for i=0,name.string_len-1 do str = str .. string.char(freetype.string_getitem(_str,i)) end
            print(str)
            print(name.string,name.string_len,6)
	else 
	    print(string.format("{unsupported encoding %d}", name.encoding_id) )
	end
      elseif name.platform_id == freetype.TT_PLATFORM_MICROSOFT then
          if ( name.language_id ~= freetype.TT_MS_LANGID_ENGLISH_UNITED_STATES ) then 
            print( string.format(" (language=0x%04x)", name.language_id )) 
          end

          if  name.encoding_id == freetype.TT_MS_ID_SYMBOL_CS or 
	      name.encoding_id == freetype.TT_MS_ID_UNICODE_CS then 
            -- /* TT_MS_ID_SYMBOL_CS is supposed to be Unicode, according to */
            -- /* information from the MS font development team              */
              local _str,str = name.string ,''
              put_unicode_be16(_str,name.string_len,6)
              --for i=0,name.string_len-1 do str = str .. string.char(freetype.string_getitem(_str,i)) print(i,freetype.string_getitem(_str,i))  end
	      --	          print("::"..str,name.string_len)
          else 
              print(string.format("{unsupported encoding %d}", name.encoding_id) )
          end
      else  
         print(string.format(" unsupported platform %d", name.platform_id) )
      end 
    end
  end
end

----------------------main()-------------------------

-- for k, v in pairs(freetype) do print(k,v) end os.exit(1)


filename = "euler.otf"
--filename = "antpb10.pfb"
p_library = freetype.new_Pointer_FT_Library()
error = freetype.FT_Init_FreeType(p_library)
if (error ~= 0) then 
    print(error)
    os.exit(error)
end
library = freetype.Pointer_FT_Library_value(p_library)

p_face = freetype.new_Pointer_FT_Face()
error = freetype.FT_New_Face( library , filename, 0, p_face )
if (error ~= 0 ) then 
    print(string.format("Error on FT_New_Face:%x",error))
    os.exit(1)
end	
face = freetype.Pointer_FT_Face_value(p_face)
num_faces = face.num_faces
print(string.format("num. of faces:%d",num_faces))

freetype.FT_Done_Face( face ) 

for i =1, num_faces do
  error = freetype.FT_New_Face( library, filename, i-1, p_face );
  if error~=0 then  
        print( "Could not open face." )
	os.exit(1)
  end	
  print( string.format("\n----- Face number: %d -----\n", i) );

  --   Print_Name( FT_Face  face )
  print( "font name entries" );
  --   /* XXX: Foundry?  Copyright?  Version? ... */
  print(string.format( "   family:     %s", face.family_name) );
  print(string.format( "   style:      %s", face.style_name) );
  ps_name = freetype.FT_Get_Postscript_Name( face );
  if ( ps_name == 'NULL' ) then 
      ps_name = "UNAVAILABLE";
  end
  print(string.format( "   postscript: %s", ps_name) );
  print();

  --Print_Type( face );
  print( "font type entries" );

  module = face.driver.root;
  print( string.format("   FreeType driver: %s\n", module.clazz.module_name) );
  if freetype.FT_IS_SFNT( face ) >0 then 
    print( "   sfnt wrapped:","yes" )
  else 
    print( "   sfnt wrapped:" ,"no" )
  end

  if freetype.FT_IS_SCALABLE( face ) >0 then 
    print( "   is scalable:","yes" )
    if freetype.FT_HAS_MULTIPLE_MASTERS( face ) >0 then 
       print( "     is mutiple master:" ,"yes" )
    else
       print( "     is mutiple master:" ,"no" ) 
    end
  else 
    print( "   is scalable:", "no" )
  end

  if freetype.FT_HAS_FIXED_SIZES( face ) >0 then 
    print( "   fixed size:", "yes" )
  else 
    print( "   fixed size:", "no" )
  end

  if freetype.FT_HAS_HORIZONTAL( face ) >0 then 
    print( "   horizontal:", "yes" )
  else 
    print( "   horizontal:", "no" )
  end

  if freetype.FT_HAS_VERTICAL( face ) >0 then 
    print( "   vertical:", "yes" )
  else 
    print( "   vertical:", "no" )
  end

  if freetype.FT_IS_FIXED_WIDTH( face ) >0 then 
    print( "   fixed width:", "yes" )
  else 
    print( "   fixed width:", "no" )
  end

  if freetype.FT_HAS_GLYPH_NAMES( face ) >0 then 
    print( "   glyph names:", "yes" )
  else 
    print( "   glyph names:", "no" )
  end
  
  if freetype.FT_IS_SCALABLE( face ) >0 then 
    print( "   EM size:", face.units_per_EM )
    print( "   global BBox:",face.bbox.xMin, face.bbox.yMin,face.bbox.xMax, face.bbox.yMax );
    print( "   ascent:", face.ascender );
    print( "   descent:", face.descender );
    print( "   text height:", face.height );
  end

  print( "   glyph count:", face.num_glyphs) 
  name_tables = 1
  if ( name_tables>0 and freetype.FT_IS_SFNT( face )>0 ) then
        Print_Sfnt_Names( face );
  end    
  
  if face.num_fixed_sizes>0  then 
    print( "face.num_fixed_sizes",face.num_fixed_sizes );
    Print_Fixed( face );
  end

   if  face.num_charmaps then
     --print( "face.num_charmaps",face.num_charmaps );
     Print_Charmaps( face );
  end

  freetype.FT_Done_Face( face );
end

freetype.FT_Done_FreeType( library );



