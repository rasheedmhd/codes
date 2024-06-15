(* The order of elements is significant, and elements may appear more than once. 
For instance, the following lists are all different: *)

[3,4];    [4,3];    [3,4,3];    [3,3,4];

[(1,"One"), (2,"Two"), (3,"Three")] : (int*string) list;

[ [3.1], [], [5.7,  ~0.6] ]          : (real list) list;


(* Every list is either nil, if empty, or has the form x :: l where x is its head and l its tail. *)
(* • nil is a synonym for the empty list, [].
• The operator :: makes a list by putting an element in front of an existing list. *) 

nil    = [];
3::[]  = [3]
5::[3] = [5,3]
9::[5,3] = [9, 5,3]