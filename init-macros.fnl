(local utils (if (= ... :init-macros)
                 :utils
                 (or ... :utils)))

(fn assert-eq
  [expr1 expr2 msg]
  "Like `assert', except compares results of `expr1' and `expr2' for equality.
Generates formatted message if `msg' is not set to other message.

# Example
Compare two expressions:

``` fennel
(assert-eq 1 (+ 1 2))
;; => runtime error: equality assertion failed
;; =>   Left: 1
;; =>   Right: 3
```

Deep compare values:

``` fennel
(assert-eq [1 {[2 3] [4 5 6]}] [1 {[2 3] [4 5]}])
;; => runtime error: equality assertion failed
;; =>   Left:  [1 {[2 3] [4 5 6]}]
;; =>   Right: [1 {[2 3] [4 5]}]
```"
  `(let [left# ,expr1
         right# ,expr2
         {:eq eq#} (require ,utils)
         fennel# (require :fennel)
         (suc# res#) (pcall eq# left# right#)]
     (if suc#
         (do (assert res# (string.format
                           "assertion failed for expression:\n(= %s %s)\n    Left: %s\n   Right: %s\n%s"
                           ,(view expr1 {:one-line? true})
                           ,(view expr2 {:one-line? true})
                           (fennel#.view left# {:one-line? true})
                           (fennel#.view right# {:one-line? true})
                           ,(if msg (.. " Message: " msg) "")))
             nil)
         (error (string.format "in expression:\n(= %s %s)\n%s\n"
                               ,(view expr1 {:one-line? true})
                               ,(view expr2 {:one-line? true})
                               res#)))))

(fn assert-ne
  [expr1 expr2 msg]
  "Assert for unequality.  Like `assert', except compares results of
`expr1' and `expr2' for equality.  Generates formatted message if
`msg' is not set to other message.  Same as `assert-eq'."
  `(let [left# ,expr1
         right# ,expr2
         {:eq eq#} (require ,utils)
         fennel# (require :fennel)
         (suc# res#) (pcall eq# left# right#)]
     (if suc#
         (do (assert (not res#)
                     (string.format
                      "assertion failed for expression:\n(not= %s %s)\n    Left: %s\n   Right: %s\n%s"
                      ,(view expr1 {:one-line? true})
                      ,(view expr2 {:one-line? true})
                      (fennel#.view left# {:one-line? true})
                      (fennel#.view right# {:one-line? true})
                      ,(if msg (.. " Message: " msg) "")))
             nil)
         (error (string.format "in expression:\n(not= %s %s)\n%s\n"
                               ,(view expr1 {:one-line? true})
                               ,(view expr2 {:one-line? true})
                               res#)))))

(fn assert-is
  [expr msg]
  "Assert `expr' for truth. Same as inbuilt `assert', except generates more
  verbose message if `msg' is not set.

``` fennel
(assert-is (= 1 2 3))
;; => runtime error: assertion failed for (= 1 2 3)
```"
  `(let [(suc# res#) (pcall #(do ,expr))]
     (if suc#
         (do (assert res# (string.format
                           "assertion failed for expression:\n%s\n  Result: %s\n%s"
                           ,(view expr {:one-line? true})
                           (tostring res#)
                           ,(if msg (.. " Message: " msg) "")))
             nil)
         (error (string.format
                 "in expression: %s: %s\n"
                 ,(view expr {:one-line? true})
                 res#)))))

(fn assert-not
  [expr msg]
  "Assert `expr' for not truth. Generates more verbose message if
  `msg' is not set. Works the same as `assert-is'."
  `(let [(suc# res#) (pcall #(not ,expr))]
     (if suc#
         (do (assert res#
                     (string.format
                      "assertion failed for expression:\n(not %s)\n  Result: %s\n%s"
                      ,(view expr {:one-line? true})
                      (tostring res#)
                      ,(if msg (.. " Message: " msg) "")))
             nil)
         (error (string.format
                 "in expression: (not %s): %s\n"
                 ,(view expr {:one-line? true})
                 res#)))))

(fn deftest
  [_name ...]
  "Simple way of grouping tests with `name'.

# Example
``` fennel
(deftest some-test
  ;; tests
  )
```
"
  `(do ,...))

(fn testing
  [description ...]
  "Print test `description' and run it.

# Example
``` fennel
(testing \"testing something\"
  ;; test body
  )
```
"
  `(do (io.stdout:write "testing: " ,description "\n")
       ,...))

{: deftest
 : testing
 : assert-eq
 : assert-ne
 : assert-is
 : assert-not}
