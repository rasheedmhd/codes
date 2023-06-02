; handling Mutation

(def my-vec [0 1 2 3 4 5])

; replace element at index 3 with x

(def new-vec (assoc my-vec 3 :x))

(println my-vec)
(println new-vec)


; Threads
(defn random-long-between
    [mix max]
    (def max-rand (- max min))
    (long ( + min (rand max-rand))))

(defn expensive-operation
    [n]
    (let [wait-millis (random-long-between 250 750)]
        (Thread/sleep wait-millis)
        {:n n :even (even? n) :delay wait-millis}
    )
)

(defn eager-map-async
    "Applies fn fun on each element of the given sequence on a separate Thread, returning a vector with the results."
    [fun sequence]
    ; future applies the given function asyncrhonously in another Thread
    (let [async-seq (map (fn [n] (future (fun n))) sequence)]
    ; we then use '@' to de-reference each future, getting the new elements into a vector
    (vec (map (fn [fut] @fut) asycne-seq))))

(def my-vec [0 1 2 3 4 5])
; Apply and time the eager-map-async function on my-vec
    (def new-vec (time (eager-map-async expensive-operation my-vec)))

(doall (map println new-vec))