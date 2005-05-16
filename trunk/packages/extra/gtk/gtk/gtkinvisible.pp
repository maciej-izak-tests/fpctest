{
   $Id: gtkinvisible.pp,v 1.3 2005/02/14 17:13:20 peter Exp $
}

{****************************************************************************
                                 Interface
****************************************************************************}

{$ifdef read_interface}

  type
     PGtkInvisible = ^TGtkInvisible;
     TGtkInvisible = record
          bin : TGtkBin;
       end;

     PGtkInvisibleClass = ^TGtkInvisibleClass;
     TGtkInvisibleClass = record
          parent_class : TGtkBinClass;
       end;

type
  GTK_INVISIBLE=PGtkInvisible;
  GTK_INVISIBLE_CLASS=PGtkInvisibleClass;

function  GTK_INVISIBLE_TYPE:TGtkType;cdecl;external gtkdll name 'gtk_invisible_get_type';
function  GTK_IS_INVISIBLE(obj:pointer):boolean;
function  GTK_IS_INVISIBLE_CLASS(klass:pointer):boolean;

function  gtk_invisible_get_type:TGtkType;cdecl;external gtkdll name 'gtk_invisible_get_type';
function  gtk_invisible_new:PGtkWidget;cdecl;external gtkdll name 'gtk_invisible_new';

{$endif read_interface}


{****************************************************************************
                              Implementation
****************************************************************************}

{$ifdef read_implementation}

function  GTK_IS_INVISIBLE(obj:pointer):boolean;
begin
  GTK_IS_INVISIBLE:=(obj<>nil) and GTK_IS_INVISIBLE_CLASS(PGtkTypeObject(obj)^.klass);
end;

function  GTK_IS_INVISIBLE_CLASS(klass:pointer):boolean;
begin
  GTK_IS_INVISIBLE_CLASS:=(klass<>nil) and (PGtkTypeClass(klass)^.thetype=GTK_INVISIBLE_TYPE);
end;

{$endif read_implementation}


{
  $Log: gtkinvisible.pp,v $
  Revision 1.3  2005/02/14 17:13:20  peter
    * truncate log

}
