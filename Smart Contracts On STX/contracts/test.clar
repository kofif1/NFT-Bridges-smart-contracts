(use-trait nft-trait 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-trait.nft-trait)

(define-data-var collection-count uint u0)
(define-map bridge-pass {collection: principal, id: uint} uint)
(define-map collections {id: uint} principal)
(define-map collection-ids {collection: principal} uint)


(define-read-only (get-contract-owner)
  (ok (var-get contract-owner))
)

(define-private (check-is-owner)
  (ok (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED))
)

(define-public (set-contract-owner (owner principal))
  (begin
    (try! (check-is-owner))
    (ok (var-set contract-owner owner))
  )
)

(define-public (add-nonce (nft-asset-contract <nft-trait>) (nft-id uint) (takeFee bool) (dest-address (string-ascii 42)))
    (let (
        (pass-count (default-to u0 (map-get? bridge-pass {collection: (contract-of nft-asset-contract), id: nft-id})))
        )
        (map-set bridge-pass {collection: (contract-of nft-asset-contract), id: nft-id} (+ pass-count u1))
        (ok true)
    )
)

(define-read-only (get-nonce (nft-asset-contract <nft-trait>) (nft-id uint)) 
  (let (
    (pass-count (default-to u0 (map-get? bridge-pass {collection: (contract-of nft-asset-contract), id: nft-id})))
  )
  (ok pass-count))
)