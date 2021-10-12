(fn eq [...]
  "This function is able to compare tables of any depth, even if one of
the tables uses tables as keys."
  (match (select "#" ...)
    0 true
    1 true
    2 (let [(a b) ...]
        (if (rawequal a b)
            true
            (= :table (type a) (type b))
            (do (var (res count-a) (values true 0))
                (each [k v (pairs a) :until (not res)]
                  (set res (eq v (accumulate [res nil
                                              k* v (pairs b)
                                              :until res]
                                   (when (eq k* k)
                                     v))))
                  (set count-a (+ count-a 1)))
                (when res
                  (let [count-b (accumulate [res 0 _ _ (pairs b)]
                                  (+ res 1))]
                    (set res (= count-a count-b))))
                res)
            false))
    _ (let [(a b) ...]
        (and (eq a b) (eq (select 2 ...))))))

{: eq}
