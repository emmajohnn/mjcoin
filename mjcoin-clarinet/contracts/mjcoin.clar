;; title: mjcoin
;; version: 1.0.0
;; summary: A simple fungible token implemented in Clarity
;; description: mjcoin is a demonstration fungible token with basic minting and transfer functionality.

;; error codes

(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-BALANCE (err u101))
(define-constant ERR-INVALID-AMOUNT (err u102))

;; constants

(define-constant TOKEN-NAME "mjcoin")
(define-constant TOKEN-SYMBOL "MJC")
(define-constant TOKEN-DECIMALS u6)

;; data vars

(define-data-var total-supply uint u0)

;; data maps

(define-map balances
  { account: principal }
  { balance: uint }
)

;; private helpers

(define-private (get-balance-internal (who principal))
  (match (map-get? balances { account: who })
    balance-data (get balance balance-data)
    u0)
)

(define-private (set-balance (who principal) (new-balance uint))
  (if (is-eq new-balance u0)
      (map-delete balances { account: who })
      (map-set balances { account: who } { balance: new-balance }))
)

(define-private (mint-internal (amount uint) (recipient principal))
  (let (
        (current-balance (get-balance-internal recipient))
        (new-balance (+ current-balance amount))
       )
    (set-balance recipient new-balance)
    (var-set total-supply (+ (var-get total-supply) amount))
  )
)

;; public functions

;; NOTE: For demo purposes, mint is open to any caller.
;; In a production token, restrict this to an admin or DAO.
(define-public (mint (amount uint) (recipient principal))
  (begin
    (if (<= amount u0)
        ERR-INVALID-AMOUNT
        (begin
          (mint-internal amount recipient)
          (ok true)))
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (if (not (is-eq tx-sender sender))
        ERR-UNAUTHORIZED
        (if (<= amount u0)
            ERR-INVALID-AMOUNT
            (let (
                  (sender-balance (get-balance-internal sender))
                 )
              (if (< sender-balance amount)
                  ERR-INSUFFICIENT-BALANCE
                  (let (
                        (recipient-balance (get-balance-internal recipient))
                       )
                    (set-balance sender (- sender-balance amount))
                    (set-balance recipient (+ recipient-balance amount))
                    (ok true))))))
  )
)

;; read only functions

(define-read-only (get-balance (who principal))
  (ok (get-balance-internal who))
)

(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

(define-read-only (get-name)
  (ok TOKEN-NAME)
)

(define-read-only (get-symbol)
  (ok TOKEN-SYMBOL)
)

(define-read-only (get-decimals)
  (ok TOKEN-DECIMALS)
)

