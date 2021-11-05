(require-macros :init-macros)

;; This namespace can break upon compilation if (get-scope) misbehaves

(deftest vararg-test
  (testing "vararg detection"
    (let [foo (fn [...]
                (assert-eq 3 (select "#" ...))
                (assert-ne 4 (select "#" ...))
                (assert-is (= 3 (select "#" ...)))
                (assert-not (= 4 (select "#" ...))))]
      (foo nil nil nil)))
  (testing "vararg comes from macro"
    (macro foo [...]
      `((fn [...] ,...) nil nil nil))
    (foo
     (assert-eq 3 (select "#" ...))
     (assert-ne 4 (select "#" ...))
     (assert-is (= 3 (select "#" ...)))
     (assert-not (= 4 (select "#" ...))))))
