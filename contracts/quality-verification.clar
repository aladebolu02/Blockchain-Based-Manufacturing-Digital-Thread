;; Quality Verification Contract
;; Records testing and inspection results

(define-data-var contract-owner principal tx-sender)
(define-map quality-checks uint {
  product-id: uint,
  test-name: (string-utf8 50),
  result: (string-utf8 50),
  inspector: principal,
  timestamp: uint
})
(define-data-var check-counter uint u0)

(define-public (record-quality-check (product-id uint) (test-name (string-utf8 50)) (result (string-utf8 50)))
  (let ((id (+ (var-get check-counter) u1)))
    (begin
      (var-set check-counter id)
      (map-set quality-checks id {
        product-id: product-id,
        test-name: test-name,
        result: result,
        inspector: tx-sender,
        timestamp: block-height
      })
      (ok id))))

(define-read-only (get-quality-check (check-id uint))
  (map-get? quality-checks check-id))

(define-map product-quality-checks {product-id: uint, check-index: uint} uint)
(define-map product-check-count uint uint)

(define-public (link-check-to-product (product-id uint) (check-id uint))
  (let ((current-count (default-to u0 (map-get? product-check-count product-id))))
    (begin
      (map-set product-quality-checks {product-id: product-id, check-index: current-count} check-id)
      (map-set product-check-count product-id (+ current-count u1))
      (ok true))))
