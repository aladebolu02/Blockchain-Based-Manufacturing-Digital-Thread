;; Material Tracking Contract
;; Records components used in production

(define-data-var contract-owner principal tx-sender)
(define-map materials uint {
  material-id: (string-utf8 50),
  supplier: principal,
  batch: (string-utf8 50),
  timestamp: uint
})
(define-data-var material-counter uint u0)
(define-map product-materials {product-id: uint, material-index: uint} uint)
(define-map product-material-count uint uint)

(define-public (register-material (material-id (string-utf8 50)) (batch (string-utf8 50)))
  (let ((id (+ (var-get material-counter) u1)))
    (begin
      (var-set material-counter id)
      (map-set materials id {
        material-id: material-id,
        supplier: tx-sender,
        batch: batch,
        timestamp: block-height
      })
      (ok id))))

(define-public (add-material-to-product (product-id uint) (material-id uint))
  (let ((current-count (default-to u0 (map-get? product-material-count product-id))))
    (begin
      (map-set product-materials {product-id: product-id, material-index: current-count} material-id)
      (map-set product-material-count product-id (+ current-count u1))
      (ok true))))

(define-read-only (get-material (material-id uint))
  (map-get? materials material-id))

(define-read-only (get-product-material (product-id uint) (index uint))
  (map-get? product-materials {product-id: product-id, material-index: index}))

(define-read-only (get-product-material-count (product-id uint))
  (default-to u0 (map-get? product-material-count product-id)))
