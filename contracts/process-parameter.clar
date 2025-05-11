;; Process Parameter Contract
;; Monitors manufacturing conditions

(define-data-var contract-owner principal tx-sender)
(define-map process-parameters uint {
  product-id: uint,
  parameter-name: (string-utf8 50),
  parameter-value: (string-utf8 50),
  timestamp: uint
})
(define-data-var parameter-counter uint u0)

(define-public (record-parameter (product-id uint) (parameter-name (string-utf8 50)) (parameter-value (string-utf8 50)))
  (let ((id (+ (var-get parameter-counter) u1)))
    (begin
      (var-set parameter-counter id)
      (map-set process-parameters id {
        product-id: product-id,
        parameter-name: parameter-name,
        parameter-value: parameter-value,
        timestamp: block-height
      })
      (ok id))))

(define-read-only (get-parameter (parameter-id uint))
  (map-get? process-parameters parameter-id))

(define-map product-parameters {product-id: uint, parameter-index: uint} uint)
(define-map product-parameter-count uint uint)

(define-public (link-parameter-to-product (product-id uint) (parameter-id uint))
  (let ((current-count (default-to u0 (map-get? product-parameter-count product-id))))
    (begin
      (map-set product-parameters {product-id: product-id, parameter-index: current-count} parameter-id)
      (map-set product-parameter-count product-id (+ current-count u1))
      (ok true))))
