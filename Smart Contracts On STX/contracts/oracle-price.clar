
(define-read-only (get-bridge-fee (usd-value uint)) 
  (let (
    (stx-price (contract-call? 'ST10M9SK9RE5Z919TYVVMTZF9D8E0D6V8GR11BPA5.arkadiko-oracle-v1-1 get-price "STX"))
    )
    (default-to u0 (some (/ (* usd-value (get decimals stx-price)) (get last-price stx-price))))
  )
)