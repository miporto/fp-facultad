Program TrabajoPractico;

uses    Printer,DOS,CRT;

const
     MAXPASILLO = 9;
     MAXCOLUMNA = 20;
     MAXESTANTE = 5;


type
    t_NumSerie  = 0..9999; {El valor cero significa que el lugar est� vac�o}
    t_Datos     = 1..9999;
    t_Columna   = 1..20;
    t_Pasillo   = 1..9;
    t_Estante   = 1..5;


    t_Caja      = Record
                       NumSerie    : t_NumSerie;
                       CodMaterial : t_Datos;
                       Cantidad    : Integer;
                  End;

    t_Material  = Record
                       CodMaterial :t_Datos;
                       Descripcion :String[20];
                  End;

    t_Deposito  = array [t_Pasillo] of Array [t_Columna] of Array [t_Estante] of t_Caja;
    t_Vector    = array [1..(MAXPASILLO+MAXESTANTE+MAXCOLUMNA-1)] of t_Caja;

    t_fMaterial = file of t_Material;
    t_fDeposito = file of t_Caja;

var

   Caja      : t_Caja;
   Deposito  : t_Deposito;
   fMaterial : t_fMaterial;
   fStock    : t_fDeposito;
   Auto      : Boolean;



Procedure Abrir (var archivo : file);
Begin
{$I-}
reset (archivo);
{$I+}
if IOResult <>0 then rewrite (archivo);
End;

Procedure FueraDeRango (a,b:integer);
Begin
writeln ('Ingresar s�lo valores entre ',a,' y ',b);
End;

Procedure Lugar (var Pasillo : t_pasillo; var Columna : t_Columna; var estante : t_estante);

    Begin

        Repeat
        write('Ingrese el n�mero de pasillo (1-9): ');
        {$I-}
        readln (Pasillo);
        {$I+}
        if (IOResult <> 0)  then Pasillo := 0;
        if (Pasillo > MAXPASILLO) or (Pasillo <= 0) then FueraDeRango (1, MAXPASILLO);
        until (Pasillo <= MAXPASILLO) and (Pasillo > 0);

        Repeat
        write('Ingrese el n�mero de columna (1-20): ');
        {$I-}
        readln (Columna);
        {$I+}
        if (IOResult <> 0) then Columna := 0;
        if (Columna > MAXCOLUMNA) or (Columna <= 0) then FueraDeRango (1,MAXCOLUMNA);
        until (Columna <= MAXCOLUMNA) and (Columna > 0);

        Repeat
        write('Ingrese el n�mero de estante (1-5): ');
        {$I-}
        readln (Estante);
        {$I+}
        if (IOResult <> 0)  then Estante := 0;
        if (Estante > MAXESTANTE) or (Estante <= 0) then FueraDeRango (1, MAXESTANTE);
        until (Estante <= MAXESTANTE) and (Estante > 0);

    End;



function BuscarNumSerie (var Deposito : t_Deposito; var Caja : t_Caja ;
                         var Pasillo : t_Pasillo; var Columna : t_Columna;
                         var Estante : t_Estante) : boolean;

var
        i,j,k          : integer;
        Encontrado     : boolean;

Begin
Encontrado:= false;
i:=1;
while (i <= MAXPASILLO) and (Not (Encontrado)) do
     Begin
        j:=1;
        while (j <= MAXCOLUMNA) and (Not (Encontrado)) do
             Begin
                k:=1;
                while (k <= MAXESTANTE) and (Not (Encontrado)) do
                Begin
                   if Deposito[i][j][k].NumSerie = Caja.NumSerie then
                        Begin
                                Pasillo:=i;
                                Columna:=j;
                                Estante:=k;
                                Caja:= Deposito[Pasillo][Columna][Estante];
                                Encontrado:= true;
                        End;
                inc(k);
                End;
             Inc(j);
             End;
     inc(i);
     End;

BuscarNumSerie:=Encontrado;
End;




function BuscarLugar(var Pasillo : t_Pasillo; var Columna : t_Columna; var Estante : t_Estante; Deposito : t_Deposito; var Posicion : String) : Boolean;

     var
        posPas,posCol,posEst      : Integer;
        Encontrado                : Boolean;
        i                         : t_Pasillo;
        j                         : t_Columna;
        k                         : t_Estante;



     Begin

         i := 1;
         Encontrado := false;
         if (Deposito[Pasillo][Columna][Estante].NumSerie = 0 ) AND (Posicion <> 'f') then
            Begin
                BuscarLugar := True;
            End
         else       { Esta parte es para el segundo enunciado, donde se pide encontrar la primer posicion libre }
            Begin
                  While (i <= MAXPASILLO) and (not Encontrado) do
                     Begin
                       j := 1;
                       While (j <= MAXCOLUMNA) and (not Encontrado) do
                          Begin
                            k := 1;
                            While (k <= MAXESTANTE) and (not Encontrado) do
                                Begin
                                     if (Deposito[i][j][k].NumSerie = 0) then
                                        Begin
                                             Encontrado := true;
                                             posPas     := i;
                                             posCol     := j;
                                             posEst     := k;
                                        End;
                                     inc(k);
                                End;
                            inc(j);
                          End;
                       inc(i);
                     End;
                  Pasillo := posPas;
                  Columna := posCol;
                  estante := posEst;
                  BuscarLugar := False;
            End;
     End;



procedure RegistrarCaja(Pasillo : t_Pasillo; Columna : t_Columna; Estante : t_Estante; var Deposito : t_Deposito; Caja : t_Caja);

     Begin
         Deposito[Pasillo][Columna][Estante] := Caja;
         Writeln('Caja ingresada con �xito');
         writeln;
         write ('Presione cualquier tecla para volver al menu principal...');
         Readkey;
     End;


procedure DefinirCaja(var Caja : t_Caja; var Existe : boolean);

var     a : t_Pasillo;
        b : t_Columna;
        c : t_Estante;

     Begin
         Repeat
         Write('Por favor ingrese el n�mero de serie de la caja: ');
         {$I-}
         readln (Caja.NumSerie);
         {$I+}
         if (IOResult <> 0)  then Caja.NumSerie := 0;
         if (Caja.NumSerie > 9999) or (Caja.NumSerie <= 0) then FueraDeRango (1,9999);
         until (Caja.NumSerie <= 9999) and (Caja.NumSerie > 0);

         if (BuscarNumSerie (Deposito,Caja,a,b,c) = true) then
         Begin
                writeln ('Ya hay una caja con ese n�mero de serie');
                Existe := True;
                writeln;
                write ('Presione cualquier tecla para volver al menu principal...');
                Readkey;
         End
         else
                Begin
                        Repeat
                        Write('Por favor ingrese el C�digo del material que contiene la caja: ');
                        {$I-}
                        readln (Caja.CodMaterial);
                        {$I+}
                        if (IOResult <> 0)  then Caja.CodMaterial := -1;
                        if (Caja.CodMaterial > 9999) or (Caja.CodMaterial < 0) then FueraDeRango (0,9999);
                        until (Caja.CodMaterial <= 9999) and (Caja.CodMaterial >= 0);

                        Repeat
                        Write('Por favor ingrese la cantidad del material en la caja: ');
                        {$I-}
                        readln (Caja.Cantidad);
                        {$I+}
                        if (IOResult <> 0)  then Caja.Cantidad := -1;
                        if (Caja.Cantidad < 0) then Writeln ('Ingresar s�lo valores enteros positivos');
                        until (Caja.Cantidad >= 0);
                  Existe := False;
                End;
     End;


function IngCajaDetLugar(var Caja : t_Caja; var Deposito : t_Deposito;var Pasillo : t_pasillo; var Columna : t_Columna; var estante : t_estante; Auto : boolean ) : Boolean;     {Le permite al usuario ingresar el lugar donde se guardara la caja}
                                                                         {Llama al procemdimiento BuscarLugar, para validar que ese lugar este libre}
    var
       posicion      : String;
       Lugar,Existe : Boolean;

    Begin
        posicion := '0';

        Lugar := BuscarLugar(pasillo,columna,estante,Deposito,posicion);
        if (not Lugar) then
          Begin
               if(NOT Auto) then
                 Begin
                      writeln('Imposible ingresar la caja en ese lugar, el lugar ya esta� ocupado');
                      writeln;
                      write ('Presione cualquier tecla para volver al menu principal...');
                      Readkey;
                 End;
           IngCajaDetLugar := False;
          End
        Else
          Begin
           DefinirCaja(Caja,Existe);
           if Not Existe then
                Begin
                        IngCajaDetLugar := True;
                        RegistrarCaja(pasillo,columna,estante,Deposito,Caja);
                End;
          End;
    End;



function IngCajaLugarVacio(var Caja : t_Caja; var Deposito : t_Deposito; var pasillo  : t_Pasillo; var columna  : t_Columna; var Estante  : t_Estante; Auto : Boolean) : Boolean;

    var
       posicion   : String;
       Lugar      : Boolean;
       Existe     : Boolean;

    Begin

        Pasillo := 1;
        columna := 1;
        estante := 1;
        posicion := 'f';
        Clrscr;
        writeln('Bienvenido, este m�dulo le permitir� depositar una caja en el primer lugar libre disponible');
        writeln('************************************************************************');
        writeln;
        DefinirCaja(Caja,Existe);
        if Not (Existe) then
           Begin
           Lugar := BuscarLugar(pasillo,columna,estante,Deposito,posicion);
           if (Pasillo = 9) AND (Columna = 20) AND (Estante = 5) then
              Begin
                   if (NOT Auto) then
                   Begin
                        writeln('Imposible ingresar la caja. El dep�sito est� lleno');
                        writeln;
                        write ('Presione cualquier tecla para volver al menu principal...');
                        Readkey;
                   End;
                   IngCajaLugarVacio := False;
              end
           else
               Begin
                        RegistrarCaja(pasillo,columna,estante,Deposito,Caja);
                        IngCajaLugarVacio := True;
               end;
          End

    End;

Procedure TituloTabla;
Begin
        Gotoxy (1,1); write ('N� de Serie');
        Gotoxy (1,2); write ('-----------');
        Gotoxy (19,1); write ('Cod. Material');
        Gotoxy (19,2); write ('-------------');
        Gotoxy (38,1); write ('Descripci�n Material');
        Gotoxy (38,2); write ('--------------------');
        Gotoxy (70,1); write ('Cantidad');
        Gotoxy (70,2); write ('--------');
End;

Procedure Graficar (NumSerie : t_NumSerie; CodMaterial : t_Datos; Material: t_Material; Cantidad,i : integer);
Begin
Gotoxy (1,i+2); write (NumSerie);
Gotoxy (19,i+2); write (CodMaterial);
Gotoxy (38,i+2); write (Material.Descripcion);
Gotoxy (70,i+2); writeln (Cantidad);
End;

function SalCajaPorPasillo(var Caja : t_Caja; var Deposito : t_Deposito; pasillo :t_pasillo; columna : t_columna; Estante : t_estante; Auto: Boolean): Boolean ;

   var

      CajaVacia : t_Caja;
      Error     : Boolean;
      Opt       : Char;

   Begin

        CajaVacia.NumSerie := 0;
        CajaVacia.CodMaterial := 1;
        CajaVacia.Cantidad := 0;
        writeln;
        if (Deposito[pasillo][columna][estante].NumSerie <> 0) then
           Begin
                Caja := Deposito[pasillo][columna][estante];
                writeln ('Caja: ');
                writeln ('Pasillo: ', Pasillo);
                writeln ('Columna: ', Columna);
                writeln ('Estante: ', Estante);
                writeln ('N�mero de Serie: ',Caja.NumSerie);
                writeln ('C�digo de Material: ',Caja.CodMaterial);
                writeln ('Cantidad de Material: ',Caja.Cantidad);
                writeln;
                if(NOT Auto) then
                Begin
                write ('Desea eliminar esta caja? (s/n): ');

                Error:= True;
                while Error do
                Begin
                        readln (Opt);
                        Error:= False;
                        case Ord (Opt) of
                                78,110:
                                        Begin
                                                writeln ('Se cancel� la eliminaci�n de la caja');
                                                writeln;
                                                write ('Presione cualquier tecla para volver al menu principal...');
                                                Readkey;
                                        End;
                                83,115:
                                        Begin
                                                Deposito[pasillo][columna][estante] := CajaVacia;
                                                writeln('Caja retirada con �xito');
                                                writeln;
                                                write ('Presione cualquier tecla para volver al menu principal...');
                                                Readkey;
                                                SalCajaPorPasillo := True;
                                        End
                        else
                             Begin
                                writeln ('Ingresar s�lo "s" o "n"');
                                write ('Desea eliminar esta caja? (s/n): ');
                                error:= True;
                             End;
                        End;
                End;
                End;

           End
        else
          Begin
          if (NOT Auto) then
          Begin
            writeln('No hay una caja en esa posici�n, la posici�n est� vac�a');
            writeln;
            write ('Presione cualquier tecla para volver al menu principal...');
            readkey;
            SalCajaPorPasillo := False;
          End;
         End;
   end;



procedure ListadoPorPasillo(var fMaterial: t_fMaterial; Deposito : t_Deposito);

    var
       Pasillo  : t_Pasillo;
       Columna  : t_Columna;
       Estante  : t_estante;
       Codigo   : t_Datos;
       Material : t_Material;
       opcion   : char;
       i        : integer;


    Begin
         i:=1;
         Reset(fMaterial);
         write('Desea sacar el listado por pantalla o por impresora? (P/I): ');
         read(opcion);
         Clrscr;
         if(opcion = 'P') or (opcion = 'p') then TituloTabla();

         for Pasillo := 1 to MAXPASILLO do
             for columna := 1 to MAXCOLUMNA do
                 for estante := 1 to MAXESTANTE do
                     if (Deposito[Pasillo][Columna][estante].NumSerie <> 0) then
                     begin
                        with Deposito[Pasillo][Columna][estante] do
                           Begin
                             codigo := CodMaterial;
                             Seek(fMaterial,codigo);
                             read(fMaterial,Material);
                             if(opcion = 'P') or (opcion = 'p') then
                                Begin
                                        Graficar (NumSerie,CodMaterial,Material,Cantidad,i);
                                        Inc (i);
                                End
                             else if (opcion = 'I') or (opcion = 'i') then
                                writeln(lst,'N� de Serie: ',NumSerie,', Cod de Material: ',CodMaterial,', Descripcion: ',Material.Descripcion,', Cantidad: ',Cantidad);
                           End;
                     End;
    writeln;
    write ('Presione cualquier tecla para volver al menu principal...');
    Readkey;
    End;


Procedure Eliminar (var Deposito : t_Deposito; Pasillo : t_Pasillo;
                    Columna : t_Columna; Estante :  t_Estante);

Begin
Deposito[Pasillo][Columna][Estante].NumSerie:=0;
writeln ('Caja eliminada exitosamente');
writeln;
write ('Presione cualquier tecla para volver al menu principal...');
readkey;
End;





procedure EgresoCajaNumSerie (var Deposito : t_Deposito; var Caja : t_Caja; Auto : Boolean);
var
    Pasillo                : t_Pasillo;
    Columna                : t_Columna;
    Estante                : t_Estante;
    Error,CajaEncontrada   : Boolean;
    Opt                    : Char;

Begin

        CajaEncontrada:= BuscarNumSerie (Deposito,Caja,Pasillo,Columna,Estante);
        if (NOT CajaEncontrada) then
           Begin
               if (Not Auto) then
                 Begin
                      writeln('No hay una caja con ese n�mero de serie');
                      writeln;
                      write ('Presione cualquier tecla para volver al menu principal...');
                      readKey;
                 End;
           End;

        if CajaEncontrada then
        Begin
                writeln ('Caja: ');
                writeln ('Pasillo: ', Pasillo);
                writeln ('Columna: ', Columna);
                writeln ('Estante: ', Estante);
                writeln ('N�mero de Serie: ',Caja.NumSerie);
                writeln ('C�digo de Material: ',Caja.CodMaterial);
                writeln ('Cantidad de Material: ',Caja.Cantidad);
                writeln;
                if(NOT Auto)then
                Begin
                     write ('Desea eliminar esta caja? (s/n): ');

                     Error:= True;
                      while Error do
                      Begin
                        readln (Opt);
                        Error:= False;
                        case Ord (Opt) of
                                78,110:
                                        Begin
                                                writeln ('Se cancel� la eliminaci�n de la caja');
                                                writeln;
                                                write ('Presione cualquier tecla para volver al menu principal...');
                                                Readkey;
                                        End;
                                83,115: Eliminar (Deposito,Pasillo,Columna,Estante);
                        else Begin
                                writeln ('Ingresar s�lo "s" o "n"');
                                write ('Desea eliminar esta caja? (s/n): ');
                                error:= True;
                             End;
                        End;
                      End;
                End
                else
                   Begin
                    Eliminar (Deposito,Pasillo,Columna,Estante);
                   End;

        End;
End;


Procedure EgresoInterface(var Deposito : t_Deposito; var Caja : t_Caja; Auto : Boolean);

begin
        Clrscr;
        writeln('Bienvenido, este m�dulo le permite registrar la salida de una caja ingresando su n�mero de serie');
        writeln('************************************************************************');

        Repeat
        write ('Por favor ingrese el n�mero de serie de la caja que desea sacar: ');
        {$I-}
        readln (Caja.NumSerie);
        {$I+}
        if (IOResult <> 0)  then Caja.NumSerie := 0;
        if (Caja.NumSerie > 9999) or (Caja.NumSerie <= 0) then FueraDeRango (0,9999);
        until (Caja.NumSerie <= 9999) AND (Caja.NumSerie > 0);

        EgresoCajaNumSerie(Deposito,Caja,Auto);
End;



Procedure CargarVector (var vector : t_vector; Deposito : t_Deposito; var l : integer);
var     i,j,k     : integer;
        CajaVacia : t_Caja;
Begin

CajaVacia.NumSerie := 0;
CajaVacia.CodMaterial := 1;
CajaVacia.Cantidad := 0;

for i:=1 to (MAXPASILLO+MAXCOLUMNA+MAXESTANTE-1) do
Vector [i] := CajaVacia;

l:=1;

for i:=1 to MAXPASILLO do
        for j:=1 to MAXCOLUMNA do
                for k:=1 to MAXESTANTE do
                        Begin
                                vector[l] := Deposito [i][j][k];
                                inc (l);
                        end
End;

Procedure Intercambio (var a,b : t_Caja);
var     aux : t_Caja;

Begin
        aux := a;
        a   := b;
        b   := aux;
End;

Procedure OrdenarVector (var V : t_Vector; largo : integer);
var     i,j     : integer;

Begin
        if (Largo > 1) then
        For i := 1 to largo-1 do
                for j := 1 to largo-i do
                    if (V[j].CodMaterial > V[j+1].CodMaterial) then Intercambio (V[j],V[J+1]);

End;

Procedure ListadoPorMaterial (var fMaterial : t_fMaterial; Deposito : t_Deposito);
var     Vector          : t_vector;
        LargoVector,i,j : integer;
        Material        : t_Material;
        Opcion          : Char;

Begin
                CargarVector (Vector,Deposito,LargoVector);
                OrdenarVector (vector,LargoVector);
                j:=1;
                Reset (fMaterial);
                write('Desea sacar el listado por pantalla o por impresora? (P/I): ');
                read(opcion);
                Clrscr;
                if(opcion = 'P') or (opcion = 'p') then TituloTabla();
                for i:=1 to LargoVector do
                Begin
                        seek(fMaterial,Vector[i].CodMaterial);
                        read(fMaterial,Material);

                        If (Vector [i].NumSerie <> 0) then
                        Begin
                                With Vector[i] do

                                if (opcion = 'P') or (opcion = 'p') then
                                Begin
                                        Graficar (NumSerie,CodMaterial,Material,Cantidad,j);
                                        Inc (j);
                                End
                                else if (opcion = 'I') or (opcion = 'i') then
                                        writeln(lst,'N� de Serie: ',NumSerie,', Cod de Material: ',CodMaterial,', Descripcion: ',Material.Descripcion,', Cantidad: ',Cantidad);
                        end;
                end;

        writeln;
        write ('Presione cualquier tecla para volver al menu principal...');
        Readkey;

End;


procedure MovAutomaticos (var Deposito : t_Deposito);

   var
      nroMov, NumSerie, Cantidad, codMaterial        : String[4];
      tipoMov, strLugar, tempPasillo, tempEstante    : char;
      Caja                                           : t_Caja;
      tempColumna                                    : String[2];
      error                                          : Integer;
      Pasillo,pas                                    : t_Pasillo;
      Columna,Col                                    : t_Columna;
      Estante,Est                                    : t_Estante;
      i                                              : Integer;
      Log,interf                                     : Text;
      Return, Encontrado                             : Boolean;
      Auto                                           : Boolean;




   Begin
        Clrscr;
        Write ('El archivo de texto que contiene los movimientos autom�ticos ');
        writeln ('debe ser renombrado "interf.txt" y estar en la misma carpeta que el programa');
        Writeln;
        Write ('Aseg�rese que el archivo se encuentre en esa carpeta y con ese nombre ');
        writeln ('y presione una tecla para iniciar los movimientos...');
        writeln;
        Assign (Interf,'Interf.txt');
        {$I-}
        Reset (interf);
        {$I+}
        If (IOResult <>0) then
        Begin
                writeln ('ERROR: No se encuentra el archivo "Interf.txt"');
                writeln;
                write ('Presione cualquier tecla para volver al menu principal...');
                Readkey;
        End;

        Auto := TRUE;
        Assign(Log,'Log.txt');

        {$I-}
        Append (log);
        {$I+}
        if (IOResult <> 0) then Rewrite(Log);
        Reset(Interf);
        while (NOT EOF(Interf)) do
        Begin
             for i := 0 to 3 do
                 read(Interf,nroMov[i]);
             write(log,nroMov);
             read(Interf,tipoMov);
             if(tipoMov = 'S') then
               Begin
                  for i:= 0 to 3 do
                      read(Interf,NumSerie[i]);
                  val(NumSerie,Caja.NumSerie,error);
                  Encontrado := BuscarNumSerie(Deposito,Caja,Pasillo,Columna,Estante);
                  if (NOT Encontrado) then
                     write(Log,'E')
                  else
                      Begin
                           EgresoCajaNumSerie (Deposito,Caja,Auto);
                           write(Log,'C');
                      End
               End
             else if(tipoMov = 'E') then
             Begin
                  for i:= 0 to 3 do
                      read(Interf,NumSerie[i]);
                  for i:= 0 to 3 do
                      read(Interf,codMaterial[i]);
                  for i:= 0 to 3 do
                      read(Interf,Cantidad[i]);
                  val(NumSerie,Caja.NumSerie,error);
                  val(codMaterial,Caja.codMaterial,error);
                  val(Cantidad,Caja.Cantidad,error);
                  read(Interf,strLugar);
                  if(strLugar = 'S') then
                     Begin
                              Return := IngCajalugarVacio(Caja,Deposito,Pasillo,Columna,Estante,Auto);
                              if(Return) then
                               Begin
                                 write(Log,'C');
                                 tempPasillo := chr(Pasillo);
                                 str(Columna,tempColumna);
                                 tempEstante := chr(Estante);
                                 write(log,tempPasillo);
                                 write(log,tempColumna);
                                 write(log,tempEstante);
                               End
                              else
                                  write(Log,'E');
                     End
                  else if(strLugar = 'N') then
                       Begin
                            read(Interf,tempPasillo);
                            for i := 0 to 1 do
                                read(Interf,tempColumna[i]);
                            read(Interf,tempEstante);
                            val(tempPasillo,pasillo,error);
                            val(tempColumna,Columna,error);
                            val(tempEstante,estante,error);
                            Return := IngCajaDetLugar(Caja,Deposito,Pasillo,Columna,estante,Auto);
                            val(tempPasillo,Pas,error);
                            val(tempColumna,Col,error);
                            val(tempEstante,Est,error);
                            if (Return) and (Pas = Pasillo) and (Col = Columna) and (Est = Estante)then
                             Begin
                              write(Log,'C');
                              write(log,tempPasillo);
                              write(log,tempColumna);
                              write(log,tempEstante);
                             end
                            else if(Return) then
                             Begin
                              write(Log,'A');
                              tempPasillo := chr(Pasillo);
                              str(Columna,tempColumna);
                              tempEstante := chr(Estante);
                              write(log,tempPasillo);
                              write(log,tempColumna);
                              write(log,tempEstante);
                             End
                            else
                             write(Log,'E');
                       End;
             End;
        End;

Close (Interf);
Close (Log);

End;




Procedure ReadStock(var Stock: t_fDeposito; var Deposito : t_Deposito);

   var
   i,j,k : Integer;

   begin
       Reset (Stock);
       If (Not EOF (Stock)) then
       for i := 0 to MAXPASILLO do
           for j := 0 to MAXCOLUMNA do
               for k := 0 to MAXESTANTE do
                   Read(Stock,Deposito[i][j][k]);
   End;


Procedure WriteStock(var Stock: t_fDeposito; var Deposito : t_Deposito);

   var
   i,j,k : Integer;

   begin
       Rewrite (Stock);
       for i := 0 to MAXPASILLO do
           for j := 0 to MAXCOLUMNA do
               for k := 0 to MAXESTANTE do
                   Write(Stock,Deposito[i][j][k]);
   End;

Procedure Menu (var Deposito : t_Deposito; Caja : t_Caja; Auto:boolean);
var     opt      : char;
        Pasillo  : t_Pasillo;
        Columna  : t_Columna;
        Estante  : t_Estante;

Begin
repeat
      Clrscr;
      writeln ('        M  E  N  U');
      writeln ('        ----------');
      writeln;
      writeln ('1.- Depositar una caja indicando el lugar');
      writeln;
      writeln ('2.- Depositar una caja en el primer lugar libre');
      writeln;
      writeln ('3.- Registrar la salida de una caja indicando el lugar');
      writeln;
      writeln ('4.- Registrar la salida de una caja indicando su n�mero de serie');
      writeln;
      writeln ('5.- Emitir un listado ordenado por lugar');
      writeln;
      writeln ('6.- Emitir un listado ordenado por material');
      writeln;
      writeln ('7.- Realizar movimientos autom�ticos desde un archivo');
      writeln;
      writeln ('8.- Salir del Programa');
      writeln;
      writeln;
      write ('Opci�n: ');
      readln (opt);

      case opt of
      '1':
          Begin
               Clrscr;
               writeln('Bienvenido, este m�dulo le permite ingresar una caja indicando el lugar');
               writeln('************************************************************************');
               writeln;
               Lugar(Pasillo,Columna,Estante);
               IngCajaDetLugar (caja,deposito,Pasillo,Columna,Estante,Auto);
          End;
      '2': IngCajaLugarVacio (caja,deposito,Pasillo,Columna,Estante,Auto);
      '3':
          Begin
               Clrscr;
               writeln('Bienvenido, este m�dulo le permite registrar la salida de una caja indicando el lugar');
               writeln('************************************************************************');
               writeln;
               Lugar(Pasillo,Columna,Estante);
               SalCajaPorPasillo (caja,deposito,Pasillo,Columna,Estante,Auto);
          End;
      '4': EgresoInterface (deposito,Caja,auto);
      '5': ListadoPorPasillo (fmaterial,deposito);
      '6': ListadoPorMaterial (fmaterial,deposito);
      '7': MovAutomaticos (Deposito);
      '8': Writeln ('Usted ha decidido salir, presione cualquier tecla...');

      End;
until opt='8';
readkey;
end;


Begin

Auto := FALSE;
Assign (fmaterial,'Material.dat');
Assign (fstock,'Stock.dat');
Reset (fmaterial);
Abrir (fstock);
ReadStock (fStock,Deposito);
Menu (Deposito,Caja,auto);
WriteStock (fStock,Deposito);
Close (fmaterial);
Close (fstock);
End.

