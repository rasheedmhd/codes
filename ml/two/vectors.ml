(* Names, Functions, Types *)

(* TUPLES *)

(* 
    Standard ML provides ordered pairs, triples, quadruples and so forth. 
    For n ≥ 2, the ordered collection of n values is called an n-tuple, or just a tuple. 

    The components of an ML tuple may themselves be tuples or any other value.
*)

(* RECORDS *)
(* An ML record has components identified by name, not by position. *)
(2.5, ~1.2);

(* 2 Names, Functions and Types : VECTORS *)
(* VECTORS *)
(* 
    The vector’s type, which in mathematical notation is real ×real, is the type of a
    pair of real numbers. Vectors are ML values and can be given names. 
*)

val zerovec = (0.0, 0.0);
val a = (1.5, 6.8);
val b = (3.6, 0.9);

(* Many functions on vectors operate on the components *)
fun lengthvec (x,y) = Math.sqrt(x*x + y*y);

(* Passing Vectors as args to functions *)
lengthvec a;
lengthvec b;

(* Declaring types for vector args  *)
fun negvec (x,y) : real*real = (~x, ~y);
fun negvecc (x,y) = (~x, ~y) : real*real;

(* Default to Int *)
fun negvecs (x,y) = (~x, ~y);
negvec (4.6, 6.30);

(* Vectors as first Class Citizens  *)
(* Vectors can be arguments and results of functions and can be given names. In *)
(* short, they have all the rights of ML's built-in values, *)
type vec = real*real;


(* Functions with multiple arguments and results *)
fun avg (x, y) = (x+y) / 2.0;

(* A func on pairs(vectors) is, in effect, a function of two arguments: 

Strictly speaking, every ML function has one argument and one result. 
Withtuples, functions can effectively have any number of arguments and results. 
Since the components of a tuple can themselves be tuples, two vectors can be paired: *)

((2.0, 3.5), zerovec);

(* The sum of vectors (x1, y1) and (x2, y2) is (x1+x2, y1+y2). In ML, this function
takes a pair of vectors. Its argument pattern is a pair of pairs: *)
(* Positional Addition *)

(* Type Definitions with the type keyword *)
type vec = real*real;

fun addvec ((x1,y1), (x2,y2)) : vec = (x1+x2, y1+y2); 
fun addvec ((x1,y1), (x2,y2)) : real*real = (x1+x2, y1+y2); 
addvec ((5.0, 6.0), (3.0, 9.0)); 
(* prints  "val it = (8.0, 15.0): vec" *)

(* Passing vectors into vectors  *)
addvec((8.9, 4.4), b);
addvec((8.9, 4.4), zerovec);

(* Vector subtraction involves subtraction of the components, but can be expressed
by vector operations: *)
fun subvec(v1,v2) = addvec(v1, negvec v2);

(* The distance between two vectors is the length of the difference: *)
fun distance(v1,v2) = lengthvec(subvec(v1,v2));


(* Since distance never refers separately to v1 or v2, it can be simplified: *)
val pairv: real * real = (11.0, 10.11);
type pairv = real * real;
fun distance pairv = lengthvec(subvec pairv);

(* Components of a pair can have different types:
Here, a real number and a vector. 
Scaling a vector means multiplying both components by a constant. *)
fun scalevec (r, (x,y)) : vec = (r*x, r*y);