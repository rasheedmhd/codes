structure Complex =
struct
  type t = real * real;
  val zero = (0.0, 0.0)
  fun sum  (((x,y), (x',y'))) = (x+x', y+y') : t;
  fun diff ((x,y), (x',y'))   = (x-x', y-y') : t;
  fun prod ((x,y), (x',y'))   = (x*x' - y*y', x*y' + x'*y) : t;
end

(* Structures  *)
(* you cannot compute with structures: 
they can only be created when the program modules are being linked together. 
Structures == encapsulated environments. *)
Int.abs 
Real.abs.