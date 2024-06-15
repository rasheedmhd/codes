(* Call-by-value / Strict Evaluation *)


fun sqr (x) : int = x*x;
fun sqr x : int = x*x;


fun zero x : int = 0;

(* Evaluation in ML: call-by-value *)
(* Constants have explicit val- ues; variables have bindings in the environment. 
So evaluation has only to deal with function calls and conditionals. *)
(* Now consider zero(sqr(sqr(sqr(2)))). The argument of zero is the expression evaluated above. 
It is evaluated but the value is ignored:
          zero(sqr(sqr(sqr(2)))) ⇒ zero(sqr(sqr(2 × 2)))
          . . .
          ⇒ zero(256) ⇒ 0 *)

(* Such waste!  but frequently a function’s result does not depend on all of its arguments. *)

(* Recursive functions under call-by-value *)

fun fact n =
if n = 0 then 1 else n*fact(n-1);

fun facti (n,p) = 
if n=0 then p else facti(n-1, n*p)


(* The special roˆle of conditional expressions.  *)
fun cond(p,x,y) : int = 
  if p then x else y;

  fun badf n = cond(n=0, 1, n*badf(n-1));

  (* Although cond never requires the values of all three of its arguments, 
  the call- by-value rule evaluates them all. The recursion cannot terminate. *)


(* Conditional and/or.  *)

(* Local Declarations  *)
fun fraction (n,d) =
let val com = gcd(n,d)
in (n div com, d div com) end;
(* We have used a let expression, which has the general form let D in E end *)
(* During evaluation, the declaration D is evaluated first: expressions within the declaration are evaluated, and their results given names.  *)


(* Hiding declarations using local
A local declaration resembles a let expression:
local D1 in D2 end
This declaration behaves like the list of declarations D1;D2 except that D1 is visible only within D2, not outside. Since a list of declarations is regarded as one declaration, both D1 and D2 can declare any number of names. *)

(* Simultaneous declarations
A simultaneous declaration defines several names at once. *)

(* Here we declare names for π, e and the logarithm of 2. *)
val pi = 4.0 * Math.atan 1.0
and e = Math.exp 1.0
and log 2 = Math .ln 2.0;
 
