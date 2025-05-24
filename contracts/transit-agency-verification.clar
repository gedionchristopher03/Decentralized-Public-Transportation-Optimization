;; Transit Agency Verification Contract
;; Manages verification and registration of transit authorities

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_AGENCY_EXISTS (err u101))
(define-constant ERR_AGENCY_NOT_FOUND (err u102))
(define-constant ERR_INVALID_STATUS (err u103))

;; Agency status constants
(define-constant STATUS_PENDING u0)
(define-constant STATUS_VERIFIED u1)
(define-constant STATUS_SUSPENDED u2)

;; Data structures
(define-map agencies
  { agency-id: uint }
  {
    name: (string-ascii 100),
    contact: (string-ascii 100),
    region: (string-ascii 50),
    status: uint,
    verified-at: uint,
    verified-by: principal
  }
)

(define-map agency-principals
  { principal: principal }
  { agency-id: uint }
)

(define-data-var next-agency-id uint u1)

;; Read-only functions
(define-read-only (get-agency (agency-id uint))
  (map-get? agencies { agency-id: agency-id })
)

(define-read-only (get-agency-by-principal (agency-principal principal))
  (match (map-get? agency-principals { principal: agency-principal })
    agency-data (get-agency (get agency-id agency-data))
    none
  )
)

(define-read-only (is-verified-agency (agency-id uint))
  (match (get-agency agency-id)
    agency (is-eq (get status agency) STATUS_VERIFIED)
    false
  )
)

;; Public functions
(define-public (register-agency (name (string-ascii 100)) (contact (string-ascii 100)) (region (string-ascii 50)))
  (let ((agency-id (var-get next-agency-id)))
    (asserts! (is-none (map-get? agency-principals { principal: tx-sender })) ERR_AGENCY_EXISTS)

    (map-set agencies
      { agency-id: agency-id }
      {
        name: name,
        contact: contact,
        region: region,
        status: STATUS_PENDING,
        verified-at: u0,
        verified-by: CONTRACT_OWNER
      }
    )

    (map-set agency-principals
      { principal: tx-sender }
      { agency-id: agency-id }
    )

    (var-set next-agency-id (+ agency-id u1))
    (ok agency-id)
  )
)

(define-public (verify-agency (agency-id uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (get-agency agency-id)
      agency (begin
        (map-set agencies
          { agency-id: agency-id }
          (merge agency {
            status: STATUS_VERIFIED,
            verified-at: block-height,
            verified-by: tx-sender
          })
        )
        (ok true)
      )
      ERR_AGENCY_NOT_FOUND
    )
  )
)

(define-public (update-agency-status (agency-id uint) (new-status uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (asserts! (or (is-eq new-status STATUS_VERIFIED)
                  (is-eq new-status STATUS_SUSPENDED)) ERR_INVALID_STATUS)

    (match (get-agency agency-id)
      agency (begin
        (map-set agencies
          { agency-id: agency-id }
          (merge agency { status: new-status })
        )
        (ok true)
      )
      ERR_AGENCY_NOT_FOUND
    )
  )
)
