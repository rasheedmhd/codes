(* 2 Names, Functions and Types : TUPLES *)
(* Selecting the components of a tuple. *)

(* Here we treat scalevec as a function returning two results, which we name xc and yc. *)

type vec = real * real;
fun scalevec (r, (x,y)) : vec = (r*x, r*y);
val (xc,yc) = scalevec(4.0, a);

(* The pattern in a val declaration can be as complicated as the argument pattern
of a function definition. 
Yes, you can do this too. *)
val ((x1,y1), (x2,y2)) = (addvec(a,b), subvec(a,b));

(* The 0-tuple and the type unit. Previously we have considered n-tuples for n ≥ 2. 
There is also a 0-tuple, written () and pronounced 'unity' which has nocomponents. *)

(* It serves as a placeholder in situations where no data needs to be
conveyed. The 0-tuple is the sole value of type unit. *)