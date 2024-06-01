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

(* INFIX OPERATORS *)
(* We take infix notation for granted in mathematics. 
Imagine doing without it. Instead of 2+2=4 we should have to write =(+(2,2),4). 
Most functional languages let programmers declare their own infix operators. *)

infix xor;

fun (p xor q) = (p orelse q) andalso not (p andalso q);

(* An ML infix directive may state a precedence from 0 to 9. 
default precedence = 0 = lowest. 
infix is left associated, while infixr is right associated. *)
infix 6 plus;
fun (a plus b) = "(" ^ a ^ "+" ^ b ^ ")";
"1" plus "2" plus "3";

infix 7 times;
fun (a times b) = "(" ^ a ^ "*" ^ b ^ ")";
"m" times "n" times "3" plus "i" plus "j" times "k";

(* right associated *)
(* It produces a # sign. (ML has no operator for powers.) *)
infix 8 pow;
fun (a pow b) = "(" ^ a ^ "#" ^ b ^ ")";
"m" times "i" pow "j" pow "2" times "n";

(* Many infix operators have symbolic names. 
Let ++ be the operator for vector addition: *)
infix ++;
fun ((x1,y1) ++ (x2,y2)) : vec = (x1+x2, y1+y2);

(* Keep symbolic names separate. 
Symbolic names can cause confusion if you run them together. 
Below, ML reads the characters +~ as one symbolic name,
then complains that this name has no value: *)

1+~3;
(* > Unknown name +~ *)
(* Symbolic names must be separated by spaces or other characters: *)
1+ ~3;

(* Taking infixes as functions. Occasionally an infix has to be treated like an ordinary function. 
In ML the keyword op overrides infix status: if ⊕ is an infix
  operator then op⊕ is the corresponding function, which can be applied to a pair
  in the usual way. *)
op++ ((2.5,0.0), (0.1,2.5));

(* Infix status can be revoked. If ⊕ is an infix operator then the directive nonfix⊕
makes it revert to ordinary function notation. 
A subsequent infix directive can make ⊕ an infix operator again.
Here we deprive ML's multiplication operator of its infix status. 
The attempt to use it produces an error message, since we may not apply 3 as a function. 
But * can be applied as a function: *)

nonfix *;
3*2;
(* > Error: Type conflict... *)
*(3,2);
> 6 : int
(* The nonfix directive is intended for interactive development of syntax, for
trying different precedences and association. Changing the infix status of established operators leads to madness. *)

(* You hear that? Pure madness, insanity *)