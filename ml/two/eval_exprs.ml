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