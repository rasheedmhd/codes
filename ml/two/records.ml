(* 2 Names, Functions and Types : TUPLES *)
(* RECORDS. *)

(* A record is a tuple whose components — called fields — have labels. *)

(* While each component of an n-tuple is identified by its position from 1 to n, *)
(* the fields of a record may appear in any order.  *)

(* A record is enclosed in braces {. . . }; each field has the form label = expression. *)

val henryV = {
                name = "Henry V",
                born = 1387,
                crowned = 1413,
                died = 1422,
                quote = "Bid them achieve me and then sell my bones"
              };