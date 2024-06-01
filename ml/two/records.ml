(* 2 Names, Functions and Types : TUPLES *)
(* RECORDS. *)

(* A record is a tuple whose components — called fields — have labels. *)

(* While each component of an n-tuple is identified by its position from 1 to n, *)
(* the fields of a record may appear in any order.  *)

(* A record is enclosed in braces {. . . }; each field has the form label = expression. *)

val henryV = {
                name    = "Henry V",
                born    = 1387,
                crowned = 1413,
                died    = 1422,
                quote   = "Bid them achieve me and then sell my bones"
              };

val richardIII = {
                name = "Richard III",
                born = 1452,
                crowned = 1483,
                died = 1485,
                quote = "Plots have I laid..."
              };

(* If we do not need all the fields, we can write three dots (...) in place of the others. *)
val {
    name=nameV,
    born=bornV, 
    ...
  } = HenryV;

(* Often we want to open up a record, making its fields directly visible. We can
specify each field in the pattern as label D label, making the variable and the
label identical. Such a specification can be shortened to simply label. We open
up Richard III: *)
val { name, born, died, quote, crowned } = richardIII ;

(* Record field selections. 
The selection #label gets the value of the given label from a record. *)

#quote richardIII ;
#died henryV - #born henryV ;

(* The n-tuple is just an abbreviation for a record with numbered fields:

Yes, a label can be a positive integer! This obscure fact about Standard ML is
worth knowing for one reason: the selector #k gets the value of component k
of an n-tuple *)

(* Partial record specifications.  *)
(* A field selection that omits some of the fields
does not completely specify the record type; a function may only be defined
over a complete record type. For instance, a function cannot be defined for all records
that have fields born and died, without specifying the full set of field names (typically
using a type constraint). This restriction makes ML records efficient but inflexible. *)

(* Declaring a record type. *)

type king =  {
  name: string,
  born: int,
  crowned: int,
  died: int,
  quote: string
};

(* We now can declare a function on type king to return the King's lifetime: *)

fun lifetime (k: king) = #die k - #born k;

(* Using a pattern, lifetime can be declared like this: *)
fun lifetime({born,died,...}: king) = died - born;
lifetime henryV ;
lifetime richardIII ;

fun lifetime({name,born,crowned,died,quote}) = died - born;