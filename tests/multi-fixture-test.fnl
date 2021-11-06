(require-macros :init-macros)

(local se {})

(use-fixtures
  :once
  (fn [t]
    (tset se :once (+ (or se.once 0) 2))
    (t)
    (assert-eq se.each 3))
  (fn [t]
    (tset se :once (* (or se.once 0) 5))
    (t)
    (assert-eq se.each 3))
  :each
  (fn [t]
    (tset se :each (+ (or se.each 0) 1))
    (t)))

(deftest fixture-test-1
  (assert-eq se.once 10))

(deftest fixture-test-2
  (assert-eq se.once 10))

(deftest fixture-test-3
  (assert-eq se.once 10))
