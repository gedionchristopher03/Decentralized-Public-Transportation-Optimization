;; Ridership Tracking Contract
;; Monitors passenger volumes and usage patterns

(define-constant ERR_UNAUTHORIZED (err u300))
(define-constant ERR_ROUTE_NOT_FOUND (err u301))
(define-constant ERR_INVALID_DATA (err u302))

;; Data structures
(define-map daily-ridership
  { route-id: uint, date: uint }
  {
    total-passengers: uint,
    peak-hour-passengers: uint,
    off-peak-passengers: uint,
    revenue: uint,
    last-updated: uint
  }
)

(define-map hourly-ridership
  { route-id: uint, date: uint, hour: uint }
  {
    passengers: uint,
    boarding-count: uint,
    alighting-count: uint
  }
)

(define-map route-statistics
  { route-id: uint }
  {
    total-lifetime-passengers: uint,
    average-daily-passengers: uint,
    peak-capacity-utilization: uint,
    last-calculated: uint
  }
)

;; Read-only functions
(define-read-only (get-daily-ridership (route-id uint) (date uint))
  (map-get? daily-ridership { route-id: route-id, date: date })
)

(define-read-only (get-hourly-ridership (route-id uint) (date uint) (hour uint))
  (map-get? hourly-ridership { route-id: route-id, date: date, hour: hour })
)

(define-read-only (get-route-statistics (route-id uint))
  (map-get? route-statistics { route-id: route-id })
)

(define-read-only (calculate-utilization-rate (passengers uint) (capacity uint))
  (if (> capacity u0)
    (/ (* passengers u100) capacity)
    u0
  )
)

;; Public functions
(define-public (record-daily-ridership
  (route-id uint)
  (date uint)
  (total-passengers uint)
  (peak-hour-passengers uint)
  (off-peak-passengers uint)
  (revenue uint))

  (begin
    ;; Validate input data
    (asserts! (is-eq (+ peak-hour-passengers off-peak-passengers) total-passengers) ERR_INVALID_DATA)

    (map-set daily-ridership
      { route-id: route-id, date: date }
      {
        total-passengers: total-passengers,
        peak-hour-passengers: peak-hour-passengers,
        off-peak-passengers: off-peak-passengers,
        revenue: revenue,
        last-updated: block-height
      }
    )

    ;; Update route statistics
    (update-route-statistics route-id total-passengers)
    (ok true)
  )
)

(define-public (record-hourly-ridership
  (route-id uint)
  (date uint)
  (hour uint)
  (passengers uint)
  (boarding-count uint)
  (alighting-count uint))

  (begin
    ;; Validate hour (0-23)
    (asserts! (< hour u24) ERR_INVALID_DATA)

    (map-set hourly-ridership
      { route-id: route-id, date: date, hour: hour }
      {
        passengers: passengers,
        boarding-count: boarding-count,
        alighting-count: alighting-count
      }
    )
    (ok true)
  )
)

(define-private (update-route-statistics (route-id uint) (daily-passengers uint))
  (let ((current-stats (default-to
    { total-lifetime-passengers: u0, average-daily-passengers: u0, peak-capacity-utilization: u0, last-calculated: u0 }
    (get-route-statistics route-id))))

    (map-set route-statistics
      { route-id: route-id }
      {
        total-lifetime-passengers: (+ (get total-lifetime-passengers current-stats) daily-passengers),
        average-daily-passengers: daily-passengers, ;; Simplified calculation
        peak-capacity-utilization: (get peak-capacity-utilization current-stats),
        last-calculated: block-height
      }
    )
  )
)

(define-public (update-capacity-utilization (route-id uint) (utilization-rate uint))
  (let ((current-stats (default-to
    { total-lifetime-passengers: u0, average-daily-passengers: u0, peak-capacity-utilization: u0, last-calculated: u0 }
    (get-route-statistics route-id))))

    (map-set route-statistics
      { route-id: route-id }
      (merge current-stats {
        peak-capacity-utilization: utilization-rate,
        last-calculated: block-height
      })
    )
    (ok true)
  )
)
